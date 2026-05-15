import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/auth_strings.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/auth_service.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AuthStrings.loginTitle,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AuthStrings.loginSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.black54),
                          ),
                          const SizedBox(height: 24),
                          AppTextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            enabled: !_isSubmitting,
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9\s-]'),
                              ),
                            ],
                            labelText: AuthStrings.phoneNumberLabel,
                            hintText: AuthStrings.phoneNumberHint,
                            prefixIcon: const Icon(
                              Icons.phone_android_outlined,
                            ),
                            validator: _validatePhoneNumber,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            enabled: !_isSubmitting,
                            scrollPadding: const EdgeInsets.only(bottom: 120),
                            onFieldSubmitted: (_) => _submit(),
                            labelText: AuthStrings.passwordLabel,
                            hintText: AuthStrings.passwordHint,
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: _isSubmitting ? null : _submit,
                            child: _isSubmitting
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(AuthStrings.signInAction),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(authServiceProvider)
          .signInWithPhonePassword(
            phoneNumber: _phoneController.text,
            password: _passwordController.text,
          );
    } catch (error) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Bad state: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String? _validatePhoneNumber(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) {
      return AuthStrings.missingPhoneNumber;
    }
    try {
      AuthService.normalizePhoneNumber(raw);
    } on StateError catch (error) {
      return error.message;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) {
      return AuthStrings.missingPassword;
    }
    return null;
  }
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english('English'),
  burmese('မြန်မာ');

  const AppLanguage(this.label);

  final String label;
}

final appLanguageProvider = NotifierProvider<AppLanguageNotifier, AppLanguage>(
  AppLanguageNotifier.new,
);

class AppLanguageNotifier extends Notifier<AppLanguage> {
  static const _storageKey = 'app_language';

  @override
  AppLanguage build() {
    unawaited(_loadSavedLanguage());
    return AppLanguage.english;
  }

  void setLanguage(AppLanguage language) {
    state = language;
    unawaited(_saveLanguage(language));
  }

  Future<void> _loadSavedLanguage() async {
    final SharedPreferences preferences;
    try {
      preferences = await SharedPreferences.getInstance();
    } catch (_) {
      return;
    }
    final savedValue = preferences.getString(_storageKey);
    if (savedValue == null) return;

    for (final language in AppLanguage.values) {
      if (language.name == savedValue) {
        state = language;
        return;
      }
    }
  }

  Future<void> _saveLanguage(AppLanguage language) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_storageKey, language.name);
    } catch (_) {
      // In tests or unsupported environments, the in-memory state is enough.
    }
  }
}

class AppStrings {
  const AppStrings(this.currentLanguage);

  final AppLanguage currentLanguage;

  bool get _my => currentLanguage == AppLanguage.burmese;

  String get appName => 'Main Ledger';
  String get ledger => _my ? 'စာရင်း' : 'Ledger';
  String get ledgerTitle => _my ? 'စာရင်း' : 'Main Ledger';
  String get ledgerDetail => _my ? 'စာရင်းအသေးစိတ်' : 'Ledger Detail';
  String get createLedger => _my ? 'စာရင်းအသစ်' : 'Create Ledger Main';
  String get createLedgerShort => _my ? 'စာရင်းအသစ်' : 'Create';
  String get ledgerSynced =>
      _my ? 'စာရင်းများ Sync ပြီးပါပြီ။' : 'Ledger mains synced.';
  String get syncLedgerTooltip =>
      _my ? 'စာရင်းများ Sync လုပ်မယ်' : 'Sync ledger mains';
  String get noLedgersTitle => _my ? 'စာရင်း မရှိသေးပါ' : 'No ledger mains yet';
  String get noLedgersMessage => _my
      ? 'ကားသမားရွေးပြီး စာရင်းအသစ် စတင်ပါ။'
      : 'Select a driver and create the first ledger main.';

  String get drivers => _my ? 'ကားသမားများ' : 'Drivers';
  String get driver => _my ? 'ကားသမား' : 'Driver';
  String get createDriver => _my ? 'ကားသမားအသစ်' : 'Create Driver';
  String get editDriver => _my ? 'ကားသမားပြင်မယ်' : 'Edit Driver';
  String get editDriverTooltip => _my ? editDriver : 'Edit driver';
  String get driverName => _my ? 'ကားသမားအမည်' : 'Driver name';
  String get vehicleNumber => _my ? 'ယာဉ်နံပါတ်' : 'Vehicle number';
  String get noDriversTitle => _my ? 'ကားသမား မရှိသေးပါ' : 'No drivers yet';
  String get noDriversMessage => _my
      ? 'စာရင်းမဆောက်ခင် ကားသမားများကို အရင်ထည့်ပါ။'
      : 'Create drivers here before creating ledger mains.';
  String get driversSynced =>
      _my ? 'ကားသမားများ Sync ပြီးပါပြီ။' : 'Drivers synced.';
  String get syncDriversTooltip =>
      _my ? 'ကားသမားများ Sync လုပ်မယ်' : 'Sync drivers';

  String get parcels => _my ? 'ပါဆယ်များ' : 'Parcels';
  String get parcelDetail => _my ? 'ပါဆယ်အသေးစိတ်' : 'Parcel Detail';
  String get scanParcel => _my ? 'ပါဆယ် Scan ဖတ်မယ်' : 'Scan Parcel';
  String get searchParcels => _my ? 'ပါဆယ်ရှာမယ်' : 'Search parcels';
  String get parcelsSynced =>
      _my ? 'ပါဆယ်များ Sync ပြီးပါပြီ။' : 'Parcels synced.';
  String get syncParcelsTooltip =>
      _my ? 'ပါဆယ်များ Sync လုပ်မယ်' : 'Sync parcels';
  String get noParcelsFound => _my ? 'ပါဆယ် မတွေ့ပါ' : 'No parcels found';
  String get noMatchingParcels =>
      _my ? 'ရှာတဲ့ပါဆယ် မတွေ့ပါ' : 'No matching parcels';
  String get syncParcelsMessage => _my
      ? 'Group mobile မှ ပါဆယ်များယူရန် Firebase Sync လုပ်ပါ။'
      : 'Sync with Firebase to load parcels from group mobile.';

  String get settings => _my ? 'Settings' : 'Settings';
  String get languageLabel => _my ? 'ဘာသာစကား' : 'Language';
  String get english => 'English';
  String get burmese => 'မြန်မာ';
  String get displayLanguage => _my ? 'ပြသမည့် ဘာသာစကား' : 'Display language';

  String get settle => _my ? 'စာရင်းရှင်းမယ်' : 'Settle';
  String get settleLedger => _my ? 'စာရင်းရှင်းမယ်' : 'Settle Ledger';
  String get editSettlement =>
      _my ? 'စာရင်း ကို ပြန်ပြင်မယ်' : 'Edit Settlement';
  String get saveChanges => _my ? 'ပြင်ဆင်မှုသိမ်းမယ်' : 'Save Changes';
  String get settlementUpdated =>
      _my ? 'စာရင်းပြင်ပြီးပါပြီ။' : 'Settlement updated.';
  String get ledgerSettled => _my ? 'စာရင်းရှင်းပြီးပါပြီ။' : 'Ledger settled.';
  String get settlementCompleted =>
      _my ? 'စာရင်းရှင်းပြီးပါပြီ။' : 'Settlement completed.';

  String get paidAmount => _my ? 'ငွေရှင်းပြီး' : 'Paid Amount';
  String get unpaidAmount => _my ? 'ငွေတောင်းရန်' : 'Unpaid Amount';
  String get totalCharges => _my ? 'စုစုပေါင်း' : 'Total Charges';
  String get commissionFee => _my ? 'ကော်မရှင်ခ' : 'Commission Fee';
  String get commissionFeeInput => _my ? commissionFee : 'Commission fee';
  String get laborFee => _my ? 'လုပ်သားခ' : 'Labor Fee';
  String get laborFeeInput => _my ? laborFee : 'Labor fee';
  String get deliveryFee => _my ? 'ပို့ဆောင်ခ' : 'Delivery Fee';
  String get deliveryFeeInput => _my ? deliveryFee : 'Delivery fee';
  String get otherFee => _my ? 'အခြားကုန်ကျငွေ' : 'Other Fee';
  String get otherFeeInput => _my ? otherFee : 'Other fee';
  String get totalFees => _my ? 'ကုန်ကျငွေစုစုပေါင်း' : 'Total Fees';
  String get netAmount => _my ? 'ကျန်ငွေ' : 'Net Amount';
  String get payReceiveAmount => _my ? 'ပေး/ရ ငွေ' : 'Pay / Receive Amount';
  String get cashAdvance => _my ? 'စိုက်ငွေ' : 'Cash Advance';
  String get advanceHeader => _my ? cashAdvance : 'Advance';

  String get receiver => _my ? 'လက်ခံသူ' : 'Receiver';
  String get receiverPhone => _my ? 'လက်ခံသူ ဖုန်း' : 'Receiver Phone';
  String get sender => _my ? 'ပို့သူ' : 'Sender';
  String get senderPhone => _my ? 'ပို့သူ ဖုန်း' : 'Sender Phone';
  String get phone => _my ? 'ဖုန်း' : 'Phone';
  String get from => _my ? 'မှ' : 'From';
  String get to => _my ? 'မြို့' : 'To';
  String get route => _my ? 'လမ်းကြောင်း' : 'Route';
  String get people => _my ? 'လူအချက်အလက်' : 'People';
  String get qty => _my ? 'အရေအတွက်' : 'Qty';
  String get charges => _my ? 'ကျသင့်ငွေ' : 'Charges';
  String get payment => _my ? 'ငွေရှင်းမှု' : 'Payment';
  String get status => _my ? 'အခြေအနေ' : 'Status';
  String get type => _my ? 'အမျိုးအစား' : 'Type';
  String get parcelType => _my ? 'ပါဆယ်အမျိုးအစား' : 'Parcel Type';
  String get trackingId => _my ? 'Tracking ID' : 'Tracking ID';
  String get dispatch => _my ? 'ပို့သည့်ရက်' : 'Dispatch';
  String get dispatchDate => _my ? 'ပို့သည့်ရက်' : 'Dispatch date';
  String get created => _my ? 'ဖန်တီးသည့်ရက်' : 'Created';
  String get note => _my ? 'မှတ်ချက်' : 'Note';
  String get remark => _my ? 'မှတ်ချက်' : 'Remark';
  String get summary => _my ? 'အကျဉ်းချုပ်' : 'Summary';

  String get print => _my ? 'Print' : 'Print';
  String get view => _my ? 'ကြည့်မယ်' : 'View';
  String get remove => _my ? 'ဖြုတ်မယ်' : 'Remove';
  String get cancel => _my ? 'မလုပ်တော့ပါ' : 'Cancel';
  String get close => _my ? 'ပိတ်မယ်' : 'Close';
  String get ok => _my ? 'OK' : 'OK';
  String get save => _my ? 'သိမ်းမယ်' : 'Save';
  String get create => _my ? 'ထည့်မယ်' : 'Create';
  String get clearSearch => _my ? 'ရှာထားတာဖျက်မယ်' : 'Clear search';
  String get logout => _my ? 'ထွက်မယ်' : 'Logout';
  String get about => _my ? 'အကြောင်း' : 'About';
  String get commissions => _my ? 'ကော်မရှင်များ' : 'Commissions';

  String statusValue(String value) {
    if (!_my) return value;
    switch (value.trim().toLowerCase()) {
      case 'draft':
        return 'မရှင်းရသေး';
      case 'settled':
        return 'ရှင်းပြီး';
      case 'cancelled':
        return 'ပယ်ဖျက်ပြီး';
      case 'received':
        return 'လက်ခံပြီး';
      case 'dispatched':
        return 'ပို့ပြီး';
      case 'arrived':
        return 'ရောက်ပြီး';
      case 'claimed':
        return 'ထုတ်ပြီး';
      default:
        return value;
    }
  }

  String paymentValue(String value) {
    if (!_my) return value;
    switch (value.trim().toLowerCase()) {
      case 'paid':
        return 'ငွေရှင်းပြီး';
      case 'unpaid':
        return 'ငွေတောင်းရန်';
      default:
        return value;
    }
  }
}

final appStringsProvider = Provider<AppStrings>((ref) {
  return AppStrings(ref.watch(appLanguageProvider));
});

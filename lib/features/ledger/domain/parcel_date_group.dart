import 'parcel_entry.dart';

class ParcelDateGroup {
  const ParcelDateGroup({required this.dateLabel, required this.parcels});

  final String dateLabel;
  final List<ParcelEntry> parcels;

  int get parcelTotal =>
      parcels.fold(0, (total, parcel) => total + parcel.parcelCount);

  int get balanceTotal =>
      parcels.fold(0, (total, parcel) => total + parcel.balance);
}

import 'package:flutter/foundation.dart';

class SelectedStore {
  final String name;
  final String phone;
  final String address;

  const SelectedStore({
    required this.name,
    required this.phone,
    required this.address,
  });
}

class StoreSelectionService {
  static final ValueNotifier<SelectedStore?> selectedStoreNotifier =
      ValueNotifier<SelectedStore?>(null);
  static final ValueNotifier<bool> pickupNotifier = ValueNotifier<bool>(false);

  static SelectedStore? get selectedStore => selectedStoreNotifier.value;
  static bool get isPickup => pickupNotifier.value;

  static void selectStore({
    required String name,
    required String phone,
    required String address,
  }) {
    selectedStoreNotifier.value = SelectedStore(
      name: name,
      phone: phone,
      address: address,
    );
    pickupNotifier.value = true;
  }

  static void setPickup(bool value) {
    pickupNotifier.value = value;
  }
}

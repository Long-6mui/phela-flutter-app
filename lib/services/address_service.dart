import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/address.dart';
import 'auth_storage.dart';

class AddressService {
  static final ValueNotifier<List<Address>> addressesNotifier =
      ValueNotifier<List<Address>>([]);
  static final ValueNotifier<Address?> selectedAddressNotifier =
      ValueNotifier<Address?>(null);

  static List<Address> get addresses => addressesNotifier.value;
  static Address? get selectedAddress => selectedAddressNotifier.value;

  static Future<void> initializeAddresses() async {
    final userEmail = await AuthStorage.getCurrentUserEmail();
    if (userEmail == null) {
      addressesNotifier.value = [];
      selectedAddressNotifier.value = null;
      return;
    }
    addressesNotifier.value = await DatabaseHelper.instance.getAddressesForUser(
      userEmail,
    );
    if (selectedAddressNotifier.value == null &&
        addressesNotifier.value.isNotEmpty) {
      selectedAddressNotifier.value = addressesNotifier.value.firstWhere(
        (address) => address.isDefault,
        orElse: () => addressesNotifier.value.first,
      );
    }
  }

  static void selectAddress(Address address) {
    selectedAddressNotifier.value = address;
  }

  static Future<void> addAddress(Address address) async {
    final List<Address> current = List.from(addressesNotifier.value);
    final Address newAddress = address.copyWith(
      isDefault: current.isEmpty ? true : address.isDefault,
    );
    final userEmail = await AuthStorage.getCurrentUserEmail();
    if (userEmail == null) return;

    await DatabaseHelper.instance.insertAddress(newAddress, userEmail);

    if (newAddress.isDefault) {
      final updated = current
          .map((item) => item.copyWith(isDefault: false))
          .toList();
      updated.add(newAddress);
      addressesNotifier.value = updated;
    } else {
      current.add(newAddress);
      addressesNotifier.value = current;
    }
  }

  static Future<void> updateAddress(String id, Address address) async {
    final List<Address> current = List.from(addressesNotifier.value);
    final userEmail = await AuthStorage.getCurrentUserEmail();
    if (userEmail == null) return;

    if (address.isDefault) {
      await DatabaseHelper.instance.clearDefaultAddressForUser(userEmail);
    }

    await DatabaseHelper.instance.updateAddress(address);

    final updated = current.map((item) {
      if (item.id != id) {
        return address.isDefault ? item.copyWith(isDefault: false) : item;
      }
      return item.copyWith(
        recipientName: address.recipientName,
        phone: address.phone,
        address: address.address,
        note: address.note,
        isDefault: address.isDefault,
      );
    }).toList();

    addressesNotifier.value = updated;
  }

  static Future<void> deleteAddress(String id) async {
    await DatabaseHelper.instance.deleteAddressById(id);
    final current = addressesNotifier.value
        .where((item) => item.id != id)
        .toList();
    if (current.isNotEmpty && !current.any((item) => item.isDefault)) {
      final first = current[0].copyWith(isDefault: true);
      await DatabaseHelper.instance.updateAddress(first);
      current[0] = first;
    }
    addressesNotifier.value = current;
  }

  static Future<void> clearAddresses() async {
    addressesNotifier.value = [];
    selectedAddressNotifier.value = null;
  }
}

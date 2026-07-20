import 'package:flutter/foundation.dart';
import '../models/address.dart';

class AddressService {
  static final ValueNotifier<List<Address>> addressesNotifier = ValueNotifier<List<Address>>([]);

  static List<Address> get addresses => addressesNotifier.value;

  static void addAddress(Address address) {
    final List<Address> current = List.from(addressesNotifier.value);
    if (current.isEmpty) {
      current.add(address.copyWith(isDefault: true));
    } else {
      current.add(address.copyWith(isDefault: false));
    }
    addressesNotifier.value = current;
  }

  static void updateAddress(String id, Address address) {
    final List<Address> current = addressesNotifier.value.map((item) {
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
    addressesNotifier.value = current;
  }

  static void deleteAddress(String id) {
    final current = addressesNotifier.value.where((item) => item.id != id).toList();
    if (current.isNotEmpty && !current.any((item) => item.isDefault)) {
      current[0] = current[0].copyWith(isDefault: true);
    }
    addressesNotifier.value = current;
  }

  static void clearAddresses() {
    addressesNotifier.value = [];
  }
}

class Address {
  final String id;
  final String recipientName;
  final String phone;
  final String address;
  final String note;
  final bool isDefault;

  Address({
    String? id,
    required this.recipientName,
    required this.phone,
    required this.address,
    this.note = '',
    this.isDefault = false,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Address copyWith({
    String? id,
    String? recipientName,
    String? phone,
    String? address,
    String? note,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      note: note ?? this.note,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

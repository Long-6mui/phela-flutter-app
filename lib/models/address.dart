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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipientName': recipientName,
      'phone': phone,
      'address': address,
      'note': note,
      'isDefault': isDefault ? 1 : 0,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id']?.toString(),
      recipientName: map['recipientName']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      note: map['note']?.toString() ?? '',
      isDefault: (map['isDefault'] ?? 0) == 1,
    );
  }
}

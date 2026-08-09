class OrderModel {
  final int? id;
  final String userEmail;
  final String storeName;
  final String itemName;
  final int quantity;
  final int totalPrice;
  final String orderDate;
  final String paymentMethod;
  final String recipientName;
  final String phone;
  final String addressStr;
  final int isPickup; 
  final String? itemsJson; // <--- THÊM TRƯỜNG NÀY ĐỂ LƯU CHI TIẾT MÓN

  OrderModel({
    this.id,
    required this.userEmail,
    required this.storeName,
    required this.itemName,
    required this.quantity,
    required this.totalPrice,
    required this.orderDate,
    required this.paymentMethod,
    required this.recipientName,
    required this.phone,
    required this.addressStr,
    required this.isPickup,
    this.itemsJson,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userEmail': userEmail,
      'storeName': storeName,
      'itemName': itemName,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'recipientName': recipientName,
      'phone': phone,
      'addressStr': addressStr,
      'isPickup': isPickup,
      'itemsJson': itemsJson,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      userEmail: map['userEmail'],
      storeName: map['storeName'],
      itemName: map['itemName'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
      orderDate: map['orderDate'],
      paymentMethod: map['paymentMethod'],
      recipientName: map['recipientName'],
      phone: map['phone'],
      addressStr: map['addressStr'],
      isPickup: map['isPickup'],
      itemsJson: map['itemsJson'],
    );
  }

  OrderModel copyWith({String? userEmail}) {
    return OrderModel(
      id: id ?? this.id,
      userEmail: userEmail ?? this.userEmail,
      storeName: storeName,
      itemName: itemName,
      quantity: quantity,
      totalPrice: totalPrice,
      orderDate: orderDate,
      paymentMethod: paymentMethod,
      recipientName: recipientName,
      phone: phone,
      addressStr: addressStr,
      isPickup: isPickup,
      itemsJson: itemsJson,
    );
  }
}
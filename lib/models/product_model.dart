class ProductModel {
  final int? id;
  final String name;
  final int price;
  final String badge;
  final String imagePath;
  final int isBestSeller;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.badge,
    required this.imagePath,
    required this.isBestSeller,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      badge: map['badge'],
      imagePath: map['imagePath'],
      isBestSeller: map['isBestSeller'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'badge': badge,
      'imagePath': imagePath,
      'isBestSeller': isBestSeller,
    };
  }
}
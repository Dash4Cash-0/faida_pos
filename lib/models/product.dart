class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  double inStock;
  final String? image;
  final bool isFavorite;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.inStock,
    required this.image,
    required this.isFavorite});

  Map<String, dynamic> toMap() {
    return {'id': id,
      'name': name,
      'description': description,
      'price': price,
      'inStock': inStock,
      'image': image,
      'isFavorite': isFavorite ? 1 : 0};
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(id: map['id'],
        name: map['name'],
        description: map['description'],
        price: map['price'],
        inStock: map['inStock'],
        image: map['image'],
        isFavorite: map['isFavorite'] == 1);
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    double? inStock,
    String? image,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
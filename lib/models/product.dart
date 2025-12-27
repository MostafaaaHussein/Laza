class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      images: (json['images'] as List<dynamic>).map((img) => img.toString()).toList(),
    );
  }
}

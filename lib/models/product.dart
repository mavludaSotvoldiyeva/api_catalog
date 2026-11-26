import 'review.dart';

class Dimensions {
  const Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  final double width;
  final double height;
  final double depth;

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    width: (json['width'] as num).toDouble(),
    height: (json['height'] as num).toDouble(),
    depth: (json['depth'] as num).toDouble(),
  );
}

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.tags,
    required this.thumbnail,
    required this.dimensions,
    required this.reviews,
    this.brand,
  });

  final int id;
  final String title;
  final double price;
  final double rating;
  final List<String> tags;
  final String thumbnail;
  final Dimensions dimensions;
  final String? brand;
  final List<Review> reviews;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    title: json['title'] as String,
    price: (json['price'] as num).toDouble(),
    rating: (json['rating'] as num).toDouble(),
    tags: (json['tags'] as List<dynamic>? ?? const [])
        .map((tag) => tag as String)
        .toList(),
    thumbnail: json['thumbnail'] as String,
    dimensions: Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>),
    brand: json['brand'] as String?,
    reviews: (json['reviews'] as List<dynamic>? ?? const [])
        .map((review) => Review.fromJson(review as Map<String, dynamic>))
        .toList(),
  );
}

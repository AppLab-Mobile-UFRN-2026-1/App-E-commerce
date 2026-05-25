class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.icon,
    this.ratingRate,
    this.ratingCount,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final String icon;
  final double? ratingRate;
  final int? ratingCount;

  String get name => title;

  String get formattedPrice => 'R\$ ${price.toStringAsFixed(2)}';

  factory Product.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'];

    return Product(
      id: _parseInt(json['id'], 'id'),
      title: _parseString(json['title'], 'title'),
      description: _parseString(json['description'], 'description'),
      price: _parseDouble(json['price'], 'price'),
      category: _parseString(json['category'], 'category'),
      imageUrl: _parseString(json['image'], 'image'),
      icon: _buildIcon(_parseString(json['title'], 'title')),
      ratingRate: _parseOptionalRatingRate(rating),
      ratingCount: _parseOptionalRatingCount(rating),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'image': imageUrl,
    };

    if (ratingRate != null || ratingCount != null) {
      json['rating'] = {
        if (ratingRate != null) 'rate': ratingRate,
        if (ratingCount != null) 'count': ratingCount,
      };
    }

    return json;
  }

  static int _parseInt(Object? value, String fieldName) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    throw FormatException('Campo "$fieldName" inválido.');
  }

  static double _parseDouble(Object? value, String fieldName) {
    if (value is num) {
      return value.toDouble();
    }

    throw FormatException('Campo "$fieldName" inválido.');
  }

  static String _parseString(Object? value, String fieldName) {
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    throw FormatException('Campo "$fieldName" inválido.');
  }

  static double? _parseOptionalRatingRate(Object? rating) {
    if (rating == null) {
      return null;
    }

    if (rating is! Map<String, dynamic>) {
      throw const FormatException('Campo "rating" inválido.');
    }

    final rate = rating['rate'];

    if (rate == null) {
      return null;
    }

    if (rate is num) {
      return rate.toDouble();
    }

    throw const FormatException('Campo "rating.rate" inválido.');
  }

  static int? _parseOptionalRatingCount(Object? rating) {
    if (rating == null) {
      return null;
    }

    if (rating is! Map<String, dynamic>) {
      throw const FormatException('Campo "rating" inválido.');
    }

    final count = rating['count'];

    if (count == null) {
      return null;
    }

    if (count is int) {
      return count;
    }

    if (count is num) {
      return count.toInt();
    }

    throw const FormatException('Campo "rating.count" inválido.');
  }

  static String _buildIcon(String title) {
    final words = title
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .toList();

    if (words.isEmpty) {
      return 'PR';
    }

    if (words.length == 1) {
      final word = words.first;
      return word.length == 1
          ? word.toUpperCase()
          : word.substring(0, 2).toUpperCase();
    }

    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}

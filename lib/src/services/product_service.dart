import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductServiceException implements Exception {
  const ProductServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ProductService {
  ProductService({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _productsUrl = Uri.parse(
    'https://fakestoreapi.com/products',
  );

  final http.Client _client;

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client.get(_productsUrl);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const ProductServiceException(
          'Não foi possível carregar os produtos.',
        );
      }

      final data = jsonDecode(response.body);

      if (data is! List) {
        throw const ProductServiceException('Resposta de produtos inválida.');
      }

      return data.map<Product>((item) {
        if (item is! Map<String, dynamic>) {
          throw const ProductServiceException('Resposta de produtos inválida.');
        }

        return Product.fromJson(item);
      }).toList();
    } on ProductServiceException {
      rethrow;
    } on FormatException {
      throw const ProductServiceException('Resposta de produtos inválida.');
    } catch (_) {
      throw const ProductServiceException('Falha ao consultar os produtos.');
    }
  }

  void dispose() {
    _client.close();
  }
}

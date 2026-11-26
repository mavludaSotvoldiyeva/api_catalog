import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/product_page.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ProductApi {
  ProductApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _host = 'dummyjson.com';

  Future<ProductPage> getProducts({int limit = 20, int skip = 0}) async {
    final uri = Uri.https(_host, '/products', {
      'limit': '$limit',
      'skip': '$skip',
    });
    return ProductPage.fromJson(await _get(uri));
  }

  Future<Product> getProduct(int id) async {
    final uri = Uri.https(_host, '/products/$id');
    return Product.fromJson(await _get(uri));
  }

  Future<ProductPage> search(String query) async {
    final uri = Uri.https(_host, '/products/search', {'q': query});
    return ProductPage.fromJson(await _get(uri));
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    http.Response response;

    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('The server took too long to respond.');
    } on http.ClientException {
      throw const ApiException(
        'No connection to the server. Check your internet connection.',
      );
    }

    if (response.statusCode != 200) {
      throw ApiException('The server returned status ${response.statusCode}.');
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('The response is not a JSON object.');
      }
      return decoded;
    } on FormatException {
      throw const ApiException('The server returned an invalid JSON response.');
    }
  }
}

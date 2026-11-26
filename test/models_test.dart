import 'dart:convert';
import 'dart:io';

import 'package:api_catalog/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('decodes product fixture', () {
    final json = jsonDecode(
      File('test/fixtures/product.json').readAsStringSync(),
    ) as Map<String, dynamic>;

    final product = Product.fromJson(json);

    expect(product.title, 'Essence Mascara Lash Princess');
    expect(product.price, isA<double>());
    expect(product.tags.length, 2);
    expect(product.reviews.length, 3);
  });

  test('missing brand and tags do not crash', () {
    final product = Product.fromJson({
      'id': 1,
      'title': 'No optional fields',
      'price': 10,
      'rating': 4,
      'thumbnail': 'thumbnail.webp',
      'dimensions': {'width': 1, 'height': 2, 'depth': 3},
      'reviews': [],
    });

    expect(product.brand, isNull);
    expect(product.tags, isEmpty);
  });
}

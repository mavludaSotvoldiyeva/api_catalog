import 'dart:convert';
import 'dart:io';

import 'package:api_catalog/data/product_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('getProducts returns one product from fixture', () async {
    final fixture = File('test/fixtures/product.json').readAsStringSync();
    final product = jsonDecode(fixture) as Map<String, dynamic>;

    final api = ProductApi(
      client: MockClient((request) async {
        expect(request.url.path, '/products');
        return http.Response(
          jsonEncode({
            'products': [product],
            'total': 194,
            'skip': 0,
            'limit': 30,
          }),
          200,
        );
      }),
    );

    final page = await api.getProducts();

    expect(page.products, hasLength(1));
    expect(page.products.first.title, 'Essence Mascara Lash Princess');
  });

  test('getProduct throws ApiException for 404', () async {
    final api = ProductApi(
      client: MockClient((request) async => http.Response('Not found', 404)),
    );

    await expectLater(api.getProduct(999), throwsA(isA<ApiException>()));
  });
}

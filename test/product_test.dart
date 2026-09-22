import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/models/product.dart';

void main() {
  test('Product fromJson works correctly', () {
    final json = {
      'id': 1,
      'title': 'iPhone',
      'description': 'Test phone',
      'price': 999.99,
      'rating': 4.5,
      'thumbnail': 'image.jpg',
      'images': ['image1.jpg', 'image2.jpg'],
    };

    final product = Product.fromJson(json);

    expect(product.id, 1);
    expect(product.title, 'iPhone');
    expect(product.description, 'Test phone');
    expect(product.price, 999.99);
    expect(product.rating, 4.5);
    expect(product.thumbnail, 'image.jpg');
    expect(product.images.length, 2);
  });
}
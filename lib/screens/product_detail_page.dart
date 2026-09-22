import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductService _productService = ProductService();

  Product? product;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProductDetail();
  }

  Future<void> loadProductDetail() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result =
      await _productService.getProductById(widget.productId);

      setState(() {
        product = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load product details';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading state
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loadProductDetail,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (product == null) {
      return const Center(
        child: Text('Product not found'),
      );
    }

    final item = product!;

    // Success state
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: item.images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  item.images[index],
                  width: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: 250,
                      child: Icon(Icons.image_not_supported),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Text(
            item.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '\$${item.price}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '⭐ ${item.rating}',
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 20),

          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            item.description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
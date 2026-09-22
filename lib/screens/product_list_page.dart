import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService _productService = ProductService();

  List<Product> products = [];

  bool isLoading = true;
  bool isLoadingMore = false;
  String? errorMessage;

  int skip = 0;
  final int limit = 20;
  bool hasMore = true;

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadProducts();

    // Load more products when the user scrolls near the bottom.
    // Disable pagination while searching to avoid mixing search results with normal products.
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          hasMore &&
          !isSearching) {
        loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        skip = 0;
        hasMore = true;
      });

      final result = await _productService.getProducts(
        limit: limit,
        skip: skip,
      );

      setState(() {
        products = result;
        skip = result.length;
        hasMore = result.length == limit;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load products';
        isLoading = false;
      });
    }
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final result = await _productService.getProducts(
        limit: limit,
        skip: skip,
      );

      setState(() {
        products.addAll(result);
        skip += result.length;
        hasMore = result.length == limit;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        setState(() {
          isSearching = false;
        });

        loadProducts();
      } else {
        searchProducts(query.trim());
      }
    });
  }

  Future<void> searchProducts(String query) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        isSearching = true;
      });

      final result = await _productService.searchProducts(query);

      setState(() {
        products = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to search products';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
      ),
      body: Column( //search bar
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),

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
              onPressed: loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (products.isEmpty) {
      return const Center(
        child: Text('No products found'),
      );
    }

    // Success state //pull to refresh
    return RefreshIndicator(
      onRefresh: loadProducts,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: products.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == products.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final product = products[index];

          return ListTile(
            leading: Image.network( //Image loading placeholder / error handling
              product.thumbnail,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    Icons.image_not_supported,
                  ),
                );
              },
            ),
            title: Text(product.title),
            subtitle: Text('\$${product.price}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    productId: product.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
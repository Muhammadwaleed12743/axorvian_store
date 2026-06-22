import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/constants.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'all'; 
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _skip = 0;
  static const int _limit = 30;
  bool _hasMore = true;

  List<Product> get products => _filteredProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _hasMore;

  List<Product> get featuredProducts =>
      _allProducts.where((p) => p.rating >= 4.5).take(8).toList();

  List<Product> get onSaleProducts =>
      _allProducts.where((p) => p.discountPercentage >= 10).take(10).toList();

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _skip = 0;
      _hasMore = true;
      _allProducts.clear();
      _categories.clear(); 
    }
    if (_isLoading || (!_hasMore && !refresh)) return;

    _isLoading = refresh || _allProducts.isEmpty;
    _error = null;
    notifyListeners();

    try {
      final uri = Uri.parse(
          '${AppStrings.baseUrl}/products?limit=$_limit&skip=$_skip&select=id,title,description,price,discountPercentage,rating,stock,brand,category,thumbnail,images,sku,availabilityStatus,returnPolicy,shippingInformation');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final resp = ProductsResponse.fromJson(data);

        _allProducts.addAll(resp.products);
        _skip += resp.products.length;
        _hasMore = _skip < resp.total;

        await _fetchCategories();
        _applyFilters();
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      _error = 'Network error. Check your connection.';
      if (kDebugMode) print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _searchQuery.isNotEmpty) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final uri = Uri.parse(
          '${AppStrings.baseUrl}/products?limit=$_limit&skip=$_skip');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final resp = ProductsResponse.fromJson(data);
        _allProducts.addAll(resp.products);
        _skip += resp.products.length;
        _hasMore = _skip < resp.total;
        _applyFilters();
      }
    } catch (_) {}

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> _fetchCategories() async {
    if (_categories.isNotEmpty) return;
    try {
      final response = await http
          .get(Uri.parse('${AppStrings.baseUrl}/products/categories'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        _categories = ['all'] +
            list.map((e) {
              if (e is Map<String, dynamic>) {
                return e['slug']?.toString() ?? e['name']?.toString()?.toLowerCase() ?? e.toString().toLowerCase();
              }
              return e.toString().toLowerCase();
            }).toList();
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching categories: $e');
    }
  }

  Future<List<Product>> fetchByCategory(String category) async {
    try {
      // The API uses slugs. We use the category ID passed which should be the slug.
      final response = await http.get(
          Uri.parse('${AppStrings.baseUrl}/products/category/$category?limit=50'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ProductsResponse.fromJson(data).products;
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching by category: $e');
    }
    return [];
  }

  Future<void> filterByCategory(String category) async {
    _selectedCategory = category.toLowerCase();
    
    // Immediate filter of existing products
    _applyFilters();
    notifyListeners();

    if (_selectedCategory == 'all') return;

    // Check if we already have a reasonable number of products for this category
    final existingCount = _allProducts.where((p) => p.category.toLowerCase() == _selectedCategory).length;
    
    // If we have very few or no products for this category, fetch from API
    if (existingCount < 5) {
      _isLoading = true;
      notifyListeners();

      try {
        final categoryProducts = await fetchByCategory(_selectedCategory);
        
        bool added = false;
        for (var p in categoryProducts) {
          if (!_allProducts.any((existing) => existing.id == p.id)) {
            _allProducts.add(p);
            added = true;
          }
        }
        
        if (added || categoryProducts.isNotEmpty) {
          _applyFilters();
        }
      } catch (e) {
        if (kDebugMode) print('Error in filterByCategory: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<Product> result = List.from(_allProducts);

    if (_selectedCategory != 'all') {
      result = result
          .where((p) =>
      p.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((p) =>
      p.title.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q))
          .toList();
    }

    _filteredProducts = result;
  }
}
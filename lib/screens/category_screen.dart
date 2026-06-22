import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../utils/constants.dart';
import 'product_detail_screen.dart';
import 'product_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String? categoryName;
  const CategoryScreen({Key? key, this.categoryName}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();

  // Category data with CORRECT API category names
  final List<CategoryData> _categories = [
    CategoryData(
      id: 'all',
      name: 'All Products',
      icon: Icons.grid_view_rounded,
      image: 'https://images.unsplash.com/photo-1558618666-fcd25c85f5f5?w=400',
      color: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
      description: 'Everything You Need',
    ),
    CategoryData(
      id: 'smartphones',
      name: 'Smartphones',
      icon: Icons.smartphone_rounded,
      image: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=400',
      color: [Color(0xFFFF5722), Color(0xFFFF9800)],
      description: 'Latest Mobile Phones',
    ),
    CategoryData(
      id: 'laptops',
      name: 'Laptops',
      icon: Icons.laptop_rounded,
      image: 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=400',
      color: [Color(0xFF2196F3), Color(0xFF03A9F4)],
      description: 'Premium Laptops',
    ),
    CategoryData(
      id: 'fragrances',
      name: 'Fragrances',
      icon: Icons.face_retouching_natural_rounded,
      image: 'https://images.unsplash.com/photo-1594035910387-fea47794261f?w=400',
      color: [Color(0xFFE91E63), Color(0xFF9C27B0)],
      description: 'Luxury Perfumes',
    ),
    CategoryData(
      id: 'beauty',  // Changed from 'skincare' to 'beauty'
      name: 'Beauty',
      icon: Icons.spa_rounded,
      image: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
      color: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
      description: 'Beauty Products',
    ),
    CategoryData(
      id: 'mens-shirts',
      name: "Men's Shirts",
      icon: Icons.checkroom_rounded,
      image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
      color: [Color(0xFF3F51B5), Color(0xFF2196F3)],
      description: 'Stylish Collection',
    ),
    CategoryData(
      id: 'mens-shoes',
      name: "Men's Shoes",
      icon: Icons.shopping_bag_rounded,
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      color: [Color(0xFF795548), Color(0xFFFF5722)],
      description: 'Premium Footwear',
    ),
    CategoryData(
      id: 'womens-dresses',
      name: "Women's Dresses",
      icon: Icons.favorite_rounded,
      image: 'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=400',
      color: [Color(0xFFE91E63), Color(0xFFFF5722)],
      description: 'Trendy Fashion',
    ),
    CategoryData(
      id: 'womens-jewellery',
      name: 'Jewellery',
      icon: Icons.diamond_rounded,
      image: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400',
      color: [Color(0xFFFFD700), Color(0xFFFFA000)],
      description: 'Elegant Designs',
    ),
    CategoryData(
      id: 'sunglasses',
      name: 'Sunglasses',
      icon: Icons.wb_sunny_rounded,
      image: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400',
      color: [Color(0xFF607D8B), Color(0xFF9E9E9E)],
      description: 'Protect Your Eyes',
    ),
    CategoryData(
      id: 'groceries',
      name: 'Groceries',
      icon: Icons.local_grocery_store_rounded,
      image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      color: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
      description: 'Fresh & Organic',
    ),
    CategoryData(
      id: 'home-decoration',
      name: 'Home Decor',
      icon: Icons.home_work_rounded,
      image: 'https://images.unsplash.com/photo-1618220179428-22790b461013?w=400',
      color: [Color(0xFF8D6E63), Color(0xFFD7A86E)],
      description: 'Beautiful Spaces',
    ),
    CategoryData(
      id: 'kitchen-accessories',  // Added missing category
      name: 'Kitchen Accessories',
      icon: Icons.kitchen_rounded,
      image: 'https://images.unsplash.com/photo-1556912167-7e7f8b9a9a5e?w=400',
      color: [Color(0xFF607D8B), Color(0xFF9E9E9E)],
      description: 'Kitchen Essentials',
    ),
    CategoryData(
      id: 'furniture',  // Added missing category
      name: 'Furniture',
      icon: Icons.chair_rounded,
      image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
      color: [Color(0xFF795548), Color(0xFF8D6E63)],
      description: 'Premium Furniture',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pp = Provider.of<ProductProvider>(context, listen: false);
      if (widget.categoryName != null) {
        pp.filterByCategory(widget.categoryName!);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<ProductProvider>();
    final products = pp.products;
    final productCount = products.length;

    // Get selected category data
    final selectedCat = _categories.firstWhere(
          (c) => c.id == pp.selectedCategory,
      orElse: () => _categories.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.textDark),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductListScreen()),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.divider,
          ),
        ),
      ),
      body: pp.isLoading && products.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'Loading products...',
              style: TextStyle(color: AppColors.textLight),
            ),
          ],
        ),
      )
          : CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Category Header Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: selectedCat.color,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: selectedCat.color.first.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: selectedCat.image,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: selectedCat.color.first,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: selectedCat.color.first,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCat.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedCat.description,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white.withOpacity(0.7),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$productCount Products',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Shop Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: selectedCat.image,
                                height: 120,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(),
                                errorWidget: (_, __, ___) => Icon(
                                  selectedCat.icon,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Horizontal Category List
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Browse Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat.id == pp.selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          pp.filterByCategory(cat.id);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : AppColors.divider,
                              width: 1,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: AppColors.primary
                                    .withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: cat.image,
                                  width: 28,
                                  height: 28,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Icon(
                                    cat.icon,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textMedium,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Products Grid
          if (products.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      products.length > 10
                          ? 'Top Products in ${selectedCat.name}'
                          : 'Products in ${selectedCat.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (products.length > 10)
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductListScreen(
                              categoryFilter: pp.selectedCategory == 'all'
                                  ? null
                                  : pp.selectedCategory,
                            ),
                          ),
                        ),
                        child: const Text(
                          'See All →',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = products[index];
                    return _CategoryProductCard(product: product);
                  },
                  childCount: products.length > 10 ? 10 : products.length,
                ),
              ),
            ),
          ],

          // No products message
          if (products.isEmpty && !pp.isLoading) ...[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 60,
                        color: AppColors.textLight.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No products found in ${selectedCat.name}',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _CategoryProductCard extends StatelessWidget {
  final Product product;
  const _CategoryProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.divider,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.divider,
                        child: const Icon(
                          Icons.image_outlined,
                          color: AppColors.textLight,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  // Discount Badge
                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  // Rating
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.warning,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.brand,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '\$${product.discountedPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            if (product.discountPercentage > 0)
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textLight,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryData {
  final String id;
  final String name;
  final IconData icon;
  final String image;
  final List<Color> color;
  final String description;

  CategoryData({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    required this.color,
    required this.description,
  });
}
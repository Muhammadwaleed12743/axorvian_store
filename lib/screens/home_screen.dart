import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'product_list_screen.dart';
import 'category_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final _searchCtrl = TextEditingController();

  final List<_BannerData> _banners = [
    _BannerData(
      'Summer Sale',
      'Up to 60% OFF\nFashion Collections',
      'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=800', // Updated more reliable image
      [Color(0xFF7C3AED), Color(0xFF4F46E5)],
    ),
    _BannerData(
      'New Arrivals',
      'Fresh Styles\nJust Dropped',
      'https://images.unsplash.com/photo-1491933382434-500287f9b54b?w=800',
      [Color(0xFF0F766E), Color(0xFF0891B2)],
    ),
    _BannerData(
      'Flash Deals',
      'Today Only\nExclusive Offers',
      'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
      [Color(0xFFDC2626), Color(0xFFEA580C)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Widget _buildHome() {
    final pp = context.watch<ProductProvider>();
    final auth = context.watch<AuthProvider>();

    return CustomScrollView(
      slivers: [
        // Amazon-style Header
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Axorvian',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.location_on_outlined,
                              color: AppColors.textDark, size: 24),
                          onPressed: () {},
                        ),
                        BadgeWidget(
                          count: context.watch<CartProvider>().totalQuantity,
                          child: IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined,
                                color: AppColors.textDark, size: 26),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CartScreen())),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Hello, ${auth.user?.firstName ?? 'Guest'} 👋',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProductListScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: AppColors.textLight, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search products, brands...',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Categories
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: pp.categories.isEmpty
                    ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary, strokeWidth: 2))
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: pp.categories.take(10).length,
                  itemBuilder: (context, i) {
                    final cat = pp.categories[i];
                    final icons = [
                      Icons.grid_view_rounded,
                      Icons.devices_rounded,
                      Icons.checkroom_rounded,
                      Icons.face_retouching_natural,
                      Icons.fitness_center_rounded,
                      Icons.home_outlined,
                      Icons.watch_rounded,
                      Icons.sports_soccer_rounded,
                      Icons.auto_awesome_rounded,
                      Icons.kitchen_rounded,
                    ];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                CategoryScreen(categoryName: cat)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 80,
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: i == 0
                                      ? [
                                    const Color(0xFF7C3AED),
                                    const Color(0xFF4F46E5)
                                  ]
                                      : [
                                    AppColors.background,
                                    AppColors.divider
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: Icon(icons[i % icons.length],
                                  color: i == 0
                                      ? Colors.white
                                      : AppColors.textMedium,
                                  size: 26),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat.length > 9
                                  ? '${cat.substring(0, 8)}.'
                                  : cat,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: i == 0
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: i == 0
                                      ? AppColors.primary
                                      : AppColors.textMedium),
                              textAlign: TextAlign.center,
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

        // Hero Banner Carousel
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: SizedBox(
              height: 180,
              child: PageView.builder(
                itemCount: _banners.length,
                itemBuilder: (context, i) {
                  final b = _banners[i];
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: b.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: b.colors[0],
                                child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: b.colors[0],
                                child: const Icon(Icons.error, color: Colors.white),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    b.colors[0].withOpacity(0.85),
                                    b.colors[1].withOpacity(0.2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(b.title.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                        color: Colors.white.withOpacity(0.9))),
                                const SizedBox(height: 8),
                                Text(b.subtitle,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black26,
                                            offset: Offset(0, 2),
                                            blurRadius: 4,
                                          )
                                        ])),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text('SHOP NOW',
                                      style: TextStyle(
                                          color: b.colors[0],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Featured Products
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Featured',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProductListScreen()),
                  ),
                  child: const Text(
                    'See all',
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

        if (pp.isLoading)
          const SliverToBoxAdapter(
            child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: AppColors.primary),
                )),
          )
        else if (pp.featuredProducts.isEmpty)
          const SliverToBoxAdapter(
            child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    'No products found',
                    style: TextStyle(color: AppColors.textLight),
                  ),
                )),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.50, // Reduced aspect ratio to give more height
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, i) {
                  final p = pp.featuredProducts[i];
                  return ProductCard(
                    product: p,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: p)),
                    ),
                  );
                },
                childCount: pp.featuredProducts.length,
              ),
            ),
          ),

        // On Sale
        if (pp.onSaleProducts.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'On Sale',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Limited Time',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 350, // Increased height for horizontal cards
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: pp.onSaleProducts.length,
                itemBuilder: (context, i) {
                  final p = pp.onSaleProducts[i];
                  return Container(
                    width: 170,
                    margin: const EdgeInsets.only(right: 12),
                    child: ProductCard(
                      product: p,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: p)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildHome(),
      const CategoryScreen(),
      const WishlistScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _navIndex, children: tabs),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _navIndex,
            onTap: (i) => setState(() => _navIndex = i),
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textLight,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_outlined),
                  activeIcon: Icon(Icons.grid_view_rounded),
                  label: 'Categories'),
              BottomNavigationBarItem(
                icon: BadgeWidget(
                  count: context.watch<WishlistProvider>().itemCount,
                  child: const Icon(Icons.favorite_outline_rounded),
                ),
                activeIcon: const Icon(Icons.favorite_rounded),
                label: 'Wishlist',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Orders'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerData {
  final String title, subtitle, imageUrl;
  final List<Color> colors;
  _BannerData(this.title, this.subtitle, this.imageUrl, this.colors);
}

class BadgeWidget extends StatelessWidget {
  final int count;
  final Widget child;

  const BadgeWidget({
    Key? key,
    required this.count,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
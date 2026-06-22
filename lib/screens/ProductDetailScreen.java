import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../utils/constants.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
    final Product product;
  const ProductDetailScreen({Key? key, required this.product})
            : super(key: key);

    @override
    State<ProductDetailScreen> createState() =>
    _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
    int _imageIndex = 0;
    int _qty = 1;

    @override
    Widget build(BuildContext context) {
        final p = widget.product;
        final cart = context.watch<CartProvider>();
        final wishlist = context.watch<WishlistProvider>();
        final wished = wishlist.isWishlisted(p.id);
        final inCart = cart.isInCart(p.id);
        final images = p.images.isNotEmpty ? p.images : [p.thumbnail];

        return Scaffold(
                backgroundColor: AppColors.background,
                body: CustomScrollView(
                slivers: [
        // Image app bar
        SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: AppColors.surface,
                leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
        BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8)
                  ],
                ),
        child: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textDark, size: 20),
              ),
            ),
        actions: [
        GestureDetector(
                onTap: () => wishlist.toggle(p),
                child: Container(
                margin: const EdgeInsets.all(8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
        BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8)
                    ],
                  ),
        child: Icon(
                wished
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                color:
        wished ? AppColors.error : AppColors.textLight,
                size: 20,
                  ),
                ),
              ),
            ],
        flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                children: [
        PageView.builder(
                itemCount: images.length,
                onPageChanged: (i) =>
                setState(() => _imageIndex = i),
                itemBuilder: (_, i) => CachedNetworkImage(
                imageUrl: images[i],
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                color: AppColors.divider,
                child: const Center(
                child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2))),
        errorWidget: (_, __, ___) => Container(
                color: AppColors.divider,
                child: const Icon(Icons.image_outlined,
                size: 60,
                color: AppColors.textLight)),
                    ),
                  ),
        // Page indicators
        if (images.length > 1)
            Positioned(
                    bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(
                horizontal: 3),
        width: _imageIndex == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                color: _imageIndex == i
                ? AppColors.primary
                : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

        // Product info
        SliverToBoxAdapter(
                child: Container(
                decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius:
        BorderRadius.vertical(top: Radius.circular(28)),
              ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        // Brand + Category
        Row(
                children: [
        Container(
                padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                        ),
        child: Text(p.brand,
                style: const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
        Text(p.category,
                style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
        Text(p.title,
                style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.2)),
                  const SizedBox(height: 10),

        // Rating & Stock
        Row(
                children: [
                      const Icon(Icons.star_rounded,
                color: AppColors.warning, size: 16),
                      const SizedBox(width: 4),
        Text(p.rating.toStringAsFixed(1),
                style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textDark)),
                      const SizedBox(width: 12),
        Container(
                padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
                color: p.stock > 0
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                        ),
        child: Text(
                p.stock > 0
                        ? '${p.stock} in stock'
                        : 'Out of stock',
                style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: p.stock > 0
                ? AppColors.success
                : AppColors.error),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

        // Price
        Row(
                children: [
        Text(
                '\$${p.discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.primary),
                      ),
        if (p.discountPercentage > 0) ...[
                        const SizedBox(width: 10),
        Text(
                '\$${p.price.toStringAsFixed(2)}',
                style: const TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
                decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(width: 8),
        Container(
                padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(6),
                          ),
        child: Text(
                '-${p.discountPercentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

        // Description
                  const Text('Description',
                style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
                  const SizedBox(height: 8),
        Text(p.description,
                style: const TextStyle(
                color: AppColors.textLight,
                height: 1.5,
                fontSize: 13)),
                  const SizedBox(height: 24),

        // Quantity selector
        Row(
                children: [
                      const Text('Quantity',
                style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textDark)),
                      const Spacer(),
                Container(
                        decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                        ),
        child: Row(
                children: [
        _QtyBtn(
                icon: Icons.remove_rounded,
                onTap: () {
            if (_qty > 1)
                setState(() => _qty--);
        },
                            ),
        Padding(
                padding: const EdgeInsets.symmetric(
                horizontal: 16),
        child: Text('$_qty',
                style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textDark)),
                            ),
        _QtyBtn(
                icon: Icons.add_rounded,
                onTap: () => setState(() => _qty++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

        // Reviews
        if (p.reviews.isNotEmpty) ...[
                    const Text('Reviews',
                style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    ...p.reviews.map((r) => Container(
                margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                      ),
        child: Column(
                crossAxisAlignment:
        CrossAxisAlignment.start,
                children: [
        Row(
                mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
                children: [
        Text(r.reviewerName,
                style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textDark)),
        Row(
                children: List.generate(
                5,
                (i) => Icon(
                        Icons.star_rounded,
                        size: 13,
                color: i < r.rating
                ? AppColors.warning
                : AppColors.divider,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
        Text(r.comment,
                style: const TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
                height: 1.4)),
                        ],
                      ),
                    )),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

        // Bottom bar
        bottomNavigationBar: Container(
                padding: EdgeInsets.fromLTRB(
                20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
                decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
        BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, -4))
          ],
        ),
        child: Row(
                children: [
        // Total
        Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Text('Total',
                style: TextStyle(
                fontSize: 12, color: AppColors.textLight)),
        Text(
                '\$${(p.discountedPrice * _qty).toStringAsFixed(2)}',
                style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark),
                ),
              ],
            ),
            const SizedBox(width: 20),
        Expanded(
                child: ElevatedButton(
                onPressed: p.stock > 0
                ? () {
            for (int i = 0; i < _qty; i++) {
                cart.addToCart(p);
            }
            ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                            content: Text(
                    '${inCart ? 'Updated' : 'Added'} to cart!'),
            backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ));
        }
                    : null,
                style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
                ),
        child: Text(
                inCart ? 'Update Cart' : 'Add to Cart',
                style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    }
}

class _QtyBtn extends StatelessWidget {
    final IconData icon;
    final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
                onTap: onTap,
                child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
    }
}
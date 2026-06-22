import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/order.dart';
import '../utils/constants.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  final bool isNew;

  const OrderDetailScreen({
    Key? key,
    required this.order,
    this.isNew = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Hero Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4C1D95), Color(0xFF3730A3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                            color: isNew
                                ? AppColors.success.withOpacity(0.2)
                                : Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle),
                        child: Icon(
                          isNew
                              ? Icons.check_circle_rounded
                              : _statusIcon(order.status),
                          color: isNew
                              ? AppColors.success
                              : Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isNew ? 'Order Placed!' : 'Order Status',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13),
                            ),
                            Text(
                              isNew
                                  ? 'Thank you for your order'
                                  : order.statusLabel,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Progress tracker
                  _OrderProgressTracker(status: order.status),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order info
                  _SectionCard(children: [
                    _InfoRow('Order Number', '#${order.id}'),
                    _InfoRow('Order Date', _formatDate(order.createdAt)),
                    _InfoRow('Payment', order.paymentMethod),
                    _InfoRow(
                        'Total', '\$${order.total.toStringAsFixed(2)}'),
                  ]),
                  const SizedBox(height: 16),

                  // Items
                  const _SectionTitle('Order Items'),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: order.items.asMap().entries.map((e) {
                        final i = e.key;
                        final item = e.value;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: item.product.thumbnail,
                                      width: 58,
                                      height: 58,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => Container(
                                          width: 58,
                                          height: 58,
                                          color: AppColors.divider,
                                          child: const Icon(
                                              Icons.image_not_supported_rounded,
                                              color: AppColors.textLight)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.product.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13)),
                                        const SizedBox(height: 3),
                                        Text(
                                            'Qty: ${item.quantity} × \$${item.product.discountedPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textLight)),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${item.total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            if (i < order.items.length - 1)
                              const Divider(
                                  color: AppColors.divider,
                                  height: 1,
                                  indent: 14,
                                  endIndent: 14),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment summary
                  const _SectionTitle('Payment Summary'),
                  const SizedBox(height: 10),
                  _SectionCard(children: [
                    _PriceRow('Subtotal',
                        '\$${order.subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _PriceRow(
                        'Shipping',
                        order.shipping == 0
                            ? 'FREE'
                            : '\$${order.shipping.toStringAsFixed(2)}',
                        valueColor: order.shipping == 0
                            ? AppColors.success
                            : null),
                    const SizedBox(height: 8),
                    _PriceRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: AppColors.divider)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15)),
                        Text('\$${order.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: AppColors.textDark)),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // Shipping address
                  const _SectionTitle('Shipping Address'),
                  const SizedBox(height: 10),
                  _SectionCard(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.home_outlined,
                              color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Home Address',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(order.shippingAddress,
                                  style: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 13,
                                      height: 1.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Track order button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Tracking info will be sent to your email'),
                              behavior: SnackBarBehavior.floating),
                        );
                      },
                      icon: const Icon(Icons.local_shipping_outlined,
                          color: AppColors.textDark),
                      label: const Text('Track Order',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.border, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.access_time_rounded;
      case OrderStatus.processing:
        return Icons.sync_rounded;
      case OrderStatus.shipped:
        return Icons.local_shipping_rounded;
      case OrderStatus.delivered:
        return Icons.check_circle_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _OrderProgressTracker extends StatelessWidget {
  final OrderStatus status;
  const _OrderProgressTracker({required this.status});

  static const _steps = ['Confirmed', 'Processing', 'Shipped', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    final step = status.index.clamp(0, 3);
    return Row(
      children: List.generate(_steps.length, (i) {
        final done = i <= step;
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: done
                          ? AppColors.success
                          : Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: done
                          ? null
                          : Border.all(
                              color: Colors.white.withOpacity(0.2)),
                    ),
                    child: done
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 12)
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(_steps[i],
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: done
                              ? AppColors.success
                              : Colors.white.withOpacity(0.35))),
                ],
              ),
              if (i < _steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    color: i < step
                        ? AppColors.success
                        : Colors.white.withOpacity(0.15),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark));
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textLight)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _PriceRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textLight)),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor ?? AppColors.textDark)),
      ],
    );
  }
}

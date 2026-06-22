import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders.reversed.toList());

  Order? getById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Order placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double shipping,
    required double tax,
    required double total,
    required String shippingAddress,
    required String paymentMethod,
  }) {
    final order = Order(
      id: 'AX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: List.from(items),
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.processing,
      createdAt: DateTime.now(),
    );
    _orders.add(order);
    notifyListeners();
    return order;
  }
}

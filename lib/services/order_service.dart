import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/order_model.dart';
import 'auth_storage.dart';

class OrderService {
  static final ValueNotifier<List<OrderModel>> ordersNotifier =
      ValueNotifier<List<OrderModel>>([]);

  static Future<void> loadOrders() async {
    final userEmail = await AuthStorage.getCurrentUserEmail();
    if (userEmail == null) {
      ordersNotifier.value = [];
      return;
    }
    ordersNotifier.value = await DatabaseHelper.instance.getOrdersForUser(userEmail);
  }

  static Future<void> addOrder(OrderModel order) async {
    final userEmail = await AuthStorage.getCurrentUserEmail();
    if (userEmail == null) return;

    final newOrder = order.copyWith(userEmail: userEmail);
    await DatabaseHelper.instance.insertOrder(newOrder);
    
    // Tải lại danh sách sau khi thêm mới
    await loadOrders();
  }
}
// lib/services/cart_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'dart:convert';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartService with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    if (cartJson != null) {
      final cartData = jsonDecode(cartJson) as List;
      _items = cartData.map((itemData) {
        final productData = itemData['product'];
        final product = Product.fromJson(productData);
        final quantity = itemData['quantity'] as int;
        return CartItem(product: product, quantity: quantity);
      }).toList();
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = jsonEncode(
      _items.map((item) => {
        'product': item.product.toJson(),
        'quantity': item.quantity,
      }).toList(),
    );
    await prefs.setString('cart', cartJson);
  }

  void addItem(Product product) {
    final existingItemIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex] = CartItem(
        product: _items[existingItemIndex].product,
        quantity: _items[existingItemIndex].quantity + 1,
      );
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
    saveCart();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    saveCart();
  }

  void updateQuantity(int productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    final existingItemIndex = _items.indexWhere((item) => item.product.id == productId);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex] = CartItem(
        product: _items[existingItemIndex].product,
        quantity: newQuantity,
      );
      notifyListeners();
      saveCart();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    saveCart();
  }
}

// Add toJson to Product model
extension ProductX on Product {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
    };
  }
}
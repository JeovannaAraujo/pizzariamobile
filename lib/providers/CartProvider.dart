import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  CartProvider() {
    loadCart();
  }

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  void addItem(Map<String, dynamic> item) {
    final isBeverage = item.containsKey('namebebida'); // Verifica se é bebida
    final existingIndex = _items.indexWhere(
      (i) =>
          (isBeverage && i['namebebida'] == item['namebebida']) ||
          (!isBeverage &&
              i['name'] == item['name'] &&
              i['size'] == item['size']),
    );

    if (existingIndex >= 0) {
      _items[existingIndex]['quantity'] += item['quantity'];
    } else {
      _items.add({
        ...item,
        'observation':
            item['observation'] ?? '', // Garante a chave 'observation'
      });
    }
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String name, String? size, int quantity,
      {String? namebebida}) {
    final isBeverage = namebebida != null;
    final itemIndex = _items.indexWhere(
      (item) =>
          (isBeverage && item['namebebida'] == namebebida) ||
          (!isBeverage && item['name'] == name && item['size'] == size),
    );

    if (itemIndex >= 0) {
      if (quantity <= 0) {
        _items.removeAt(itemIndex);
      } else {
        _items[itemIndex]['quantity'] = quantity;
      }
      _saveCart();
      notifyListeners();
    }
  }

  void updateObservation(String name, String size, String? observation,
      {String? namebebida}) {
    final isBeverage = namebebida != null;

    // Encontra o índice do item no carrinho
    final itemIndex = _items.indexWhere(
      (item) =>
          (isBeverage && item['namebebida'] == namebebida) ||
          (!isBeverage && item['name'] == name && item['size'] == size),
    );

    // Verifica se o índice foi encontrado
    if (itemIndex != -1) {
      _items[itemIndex]['observation'] = observation; // Atualiza a observação
      notifyListeners(); // Notifica os listeners sobre a mudança
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', json.encode(_items));
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      List<Map<String, dynamic>> loadedCart = List<Map<String, dynamic>>.from(
          json.decode(cartData).map((item) => Map<String, dynamic>.from(item)));
      _items.clear();
      _items.addAll(loadedCart);
      notifyListeners();
    }
  }
}

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:tuple/tuple.dart";

typedef IsSaved = bool;
typedef Storage = Map<Product, Tuple2<Qty?, IsSaved>>;

class ProductList extends ChangeNotifier {
  final Storage _storage = {};

  bool get isEmpty => _storage.isEmpty;

  ProductList({Storage? items}) {
    if (items != null) _storage.addAll(items);
  }

  Tuple2<Qty?, IsSaved>? getItem(Product item) => _storage[item];

  Map<Product, Qty?> getAllSaved() {
    final map = <Product, Qty?>{};
    for (var entry in _storage.entries) {
      if (entry.value.item2) {
        map.addEntries([MapEntry(entry.key, entry.value.item1)]);
      }
    }
    return map;
  }

  void setItem(Product item, Tuple2<Qty?, IsSaved> data) {
    var tmp = _storage[item];
    if (tmp != null) {
      _storage[item] = Tuple2(data.item1 ?? tmp.item1, data.item2);
    }
    notifyListeners();
  }

  void addAll(Storage items) {
    _storage.addAll(items);
    notifyListeners();
  }

  Iterable<Product> getKeys() {
    return _storage.keys;
  }

  void removeAll(Iterable<Product> items) {
    items.forEach(_storage.remove);
    notifyListeners();
  }

  void updateItemsQty(Iterable<Tuple2<Product, Qty?>> itemQtyPairs) {
    for (var pair in itemQtyPairs) {
      var initial = _storage[pair.item1];
      if (initial != null) {
        _storage[pair.item1] = initial.withItem1(pair.item2);
      }
    }
    notifyListeners();
  }

  void clearSaved() {
    for (var item in _storage.keys) {
      setItem(item, const Tuple2(null, false));
    }
    notifyListeners();
  }

  void saveAll() {
    for (var item in _storage.keys) {
      setItem(item, const Tuple2(null, true));
    }
    notifyListeners();
  }

  void clear() {
    _storage.clear();
    notifyListeners();
  }
}

class Qty {
  final int _amount;
  get amount => _amount;

  Qty(this._amount) {
    if (_amount < 0) throw DataModelError.invalidQuantity();
  }

  Qty add(Qty other) => Qty(_amount + other._amount);
  Qty deduct(Qty other) =>
      _amount < other._amount ? Qty(0) : Qty(_amount - other._amount);
}

class Product {
  late final String _name;
  late final double _price;

  String get name => _name;
  double get price => _price;

  set name(String n) {
    const length = 30;
    n.length <= length
        ? _name = n
        : throw DataModelError.productNameError(
            "Product name can't be longer than $length");
  }

  set price(double price) => checkPriceDecimals(price)
      ? _price = price
      : throw DataModelError.productPriceError();

  static bool checkPriceDecimals(double p) {
    final l = p.toString().split('.');

    if (l.length > 1 && [1].length > 2) {
      return false;
    }
    return true;
  }

  Product();
}

class DataModelError implements Exception {
  final String? _cause;
  const DataModelError({String? cause}) : _cause = cause;
  factory DataModelError.productNameError(String s) => _ProductNameError(s);
  factory DataModelError.productPriceError() => _ProductPriceError();
  factory DataModelError.invalidQuantity() => _InvalidQuantity();

  @override
  String toString() => _cause ?? "null";
}

class _ProductNameError extends DataModelError {
  final String _reason;
  const _ProductNameError(this._reason);

  @override
  String toString() => _reason;
}

class _ProductPriceError extends DataModelError {
  final String cause =
      "Product Price should not contain more than 2 decimal places";
  @override
  String toString() => cause;
}

class _InvalidQuantity extends DataModelError {
  final String cause = "Quantity cannot be negative";
  @override
  String toString() => cause;
}

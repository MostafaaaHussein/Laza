import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class CartItem {
  String? id; // Firestore document ID
  final String productId; // Save only product ID in Firestore
  final Product product;
  final String size;
  int quantity;
  DateTime addedAt;

  CartItem({
    this.id,
    required this.product,
    required this.productId,
    required this.size,
    this.quantity = 1,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  // Unique key based on product id and size
  String get key => '${product.id}_$size';

  double get totalPrice => product.price * quantity;

  // Convert Firestore document to CartItem
  factory CartItem.fromFirestore(DocumentSnapshot doc, Product product) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      product: product, // You should fetch Product separately by productId
      productId: data['productId'],
      size: data['size'],
      quantity: data['quantity'],
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }

  // Convert CartItem to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'size': size,
      'quantity': quantity,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  // Convert CartItem to Order Item format for orders subcollection
  Map<String, dynamic> toOrderItem() {
    return {
      'productId': product.id,
      'productTitle': product.title,
      'productImage': product.images.isNotEmpty ? product.images[0] : '',
      'size': size,
      'quantity': quantity,
      'price': product.price,
      'totalPrice': totalPrice,
    };
  }
}

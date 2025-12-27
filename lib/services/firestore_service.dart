import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/note.dart';
import '../models/address.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'notes';

  // Get notes collection reference
  CollectionReference get _notesCollection =>
      _firestore.collection(_collectionName);

  // Stream of all notes (Read - Real-time)
  Stream<List<Note>> getNotes() {
    return _notesCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }

  // Create a new note - returns the auto-generated document ID
  Future<String?> addNote(Note note) async {
    try {
      final docRef = await _notesCollection.add(note.toMap());
      print('Note added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error adding note: $e');
      return null;
    }
  }

  // Update an existing note
  Future<void> updateNote(String id, Note note) async {
    try {
      await _notesCollection.doc(id).update(note.toMap());
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    try {
      await _notesCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  // Get a single note by ID
  Future<Note?> getNoteById(String noteId) async {
    // Validate input
    if (noteId.isEmpty) {
      print('ERROR: getNoteById called with empty noteId');
      return null;
    }

    try {
      print('Fetching note with ID: "$noteId"');
      print('Full path: ${_collectionName}/$noteId');
      
      final DocumentSnapshot doc = await _notesCollection.doc(noteId).get();

      // Debug output
      print('doc.exists: ${doc.exists}');
      print('doc.id: ${doc.id}');
      print('doc.data(): ${doc.data()}');

      if (doc.exists && doc.data() != null) {
        return Note.fromFirestore(doc);
      }

      print('Document does not exist or has no data');
      return null;
    } catch (e) {
      print('Error in getNoteById: $e');
      throw Exception('Failed to get note: $e');
    }
  }

  // =======================
  // ADDRESS (Subcollection)
  // =======================
  Future<void> saveAddress(String uid, Address address) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('address')
        .doc('shipping')
        .set(address.toMap());
  }

  Future<Address?> getAddress(String uid) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('address')
        .doc('shipping')
        .get();

    if (doc.exists && doc.data() != null) {
      return Address.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // =======================
  // FAVORITES (Subcollection)
  // =======================
  Stream<List<int>> getFavorites(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => int.parse(doc.id)).toList());
  }

  Future<void> toggleFavorite(String uid, int productId) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(productId.toString());

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({'addedAt': FieldValue.serverTimestamp()});
    }
  }

  // =======================
  // CART (Subcollection)
  // =======================
  // Fetch cart items as a stream of documents
  Stream<QuerySnapshot<Map<String, dynamic>>> getCart(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots();
  }

  Future<void> addToCart(String uid, int productId, String size, int quantity) async {
    final key = '${productId}_$size';
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(key);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.update({'quantity': FieldValue.increment(quantity)});
    } else {
      await docRef.set({
        'productId': productId,
        'size': size,
        'quantity': quantity,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateCartQuantity(String uid, String itemId, int quantity) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(itemId);

    if (quantity <= 0) {
      await docRef.delete();
    } else {
      await docRef.update({'quantity': quantity});
    }
  }

  Future<void> removeFromCart(String uid, String itemId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(itemId)
        .delete();
  }

  // =======================
  // ORDERS (Subcollection)
  // =======================
  Future<String?> placeOrder({
    required String uid,
    required List<Map<String, dynamic>> items,
    required double totalPrice,
    required Map<String, dynamic> address,
  }) async {
    try {
      final orderData = {
        'items': items,
        'totalPrice': totalPrice,
        'address': address,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('orders')
          .add(orderData);

      return docRef.id;
    } catch (e) {
      print('Error placing order: $e');
      rethrow;
    }
  }

  Future<void> clearCart(String uid) async {
    final cartSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    final batch = _firestore.batch();
    for (var doc in cartSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // =======================
  // REVIEWS (Subcollection)
  // =======================
  Stream<QuerySnapshot<Map<String, dynamic>>> getReviews(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addReview(String productId, Map<String, dynamic> reviewData) async {
    await _firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .add(reviewData);
  }

  // Get user's orders stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}

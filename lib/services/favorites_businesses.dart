import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesBusinesses {
  Future<void> addToFavorites(String userId, String businessId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayUnion([businessId])
    });
  }

  Future<void> removeFromFavorites(String userId, String businessId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayRemove([businessId])
    });
  }
}
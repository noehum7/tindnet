import 'package:cloud_firestore/cloud_firestore.dart';

/*
  Clase que maneja las operaciones de empresas favoritas en Firestore.
  - addToFavorites: Agrega una empresa a la lista de favoritos de un usuario.
  - removeFromFavorites: Elimina una empresa de la lista de favoritos de un usuario.
 */

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
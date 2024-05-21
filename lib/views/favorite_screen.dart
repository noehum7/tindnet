import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tindnet/widgets/custom_toast.dart';
import '../services/favorites_businesses.dart';
import '../widgets/custom_drawer_customer.dart';
import '../constants/app_colors.dart';

/*
/// `FavoritesScreen` es una clase que muestra una lista de las empresas favoritas del usuario.
///
/// Utiliza `FutureBuilder` para obtener las empresas favoritas del usuario de Firestore y mostrarlas en una lista.
/// Cada elemento de la lista muestra información detallada sobre una empresa, incluyendo su nombre y servicio.
///
/// Los usuarios pueden interactuar con cada elemento de la lista de dos maneras:
/// 1. Pueden ver más detalles sobre la empresa haciendo clic en el elemento de la lista. Esto abrirá un diálogo con más información.
/// 2. Pueden eliminar la empresa de sus favoritos haciendo clic en el icono de corazón roto.
///
/// Esta clase utiliza varios métodos auxiliares:
/// - `getFavoriteBusinesses`: Obtiene una lista de todas las empresas favoritas del usuario de Firestore.
/// - `_updateFavoriteBusinesses`: Actualiza la lista de empresas favoritas del usuario.
/// - `_showCompanyCardDialog`: Muestra un diálogo con más información sobre una empresa.
///
/// El método `build` de esta clase devuelve un `FutureBuilder` que espera que se complete el futuro `favoriteBusinesses`.
/// Dependiendo del estado de este futuro, muestra un spinner de carga, un mensaje de error o una lista de empresas favoritas.
 */

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<DocumentSnapshot>> favoriteBusinesses;
  FavoritesBusinesses favoritesBusinesses = FavoritesBusinesses();
  CustomToast customToast = CustomToast();

  @override
  void initState() {
    super.initState();
    favoriteBusinesses =
        getFavoriteBusinesses(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<List<DocumentSnapshot>> getFavoriteBusinesses(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    List<String> favoriteIds = List<String>.from(userData['favorites'] ?? []);
    List<DocumentSnapshot> favoriteBusinesses = [];

    for (String id in favoriteIds) {
      DocumentSnapshot businessDoc = await FirebaseFirestore.instance
          .collection('businesses')
          .doc(id)
          .get();
      favoriteBusinesses.add(businessDoc);
    }

    return favoriteBusinesses;
  }

  void _updateFavoriteBusinesses() {
    setState(() {
      favoriteBusinesses =
          getFavoriteBusinesses(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  void _showCompanyCardDialog(
      BuildContext context, Map<String, dynamic> data, String businessId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data['name'].toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: AppColors.primaryColor,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  color: AppColors.welcomeColor,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.business, size: 50),
                          title: Text(data?['name'] ?? 'Nombre no disponible',
                              style: TextStyle(fontSize: 17)),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.info_outline, size: 20),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                data?['aboutUs'] ?? 'Descripción no disponible',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.work, size: 20),
                            SizedBox(width: 10.0),
                            Text(data?['service'] ?? 'Servicio no disponible',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on, size: 20),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                  data?['location'] ??
                                      'Ubicación no disponible',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.phone, size: 20),
                            SizedBox(width: 10.0),
                            Text(data?['phone'] ?? 'Teléfono no disponible',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.email, size: 20),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                  data?['email'] ??
                                      'Email no disponible',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.web, size: 20),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                  data?['web'] ??
                                      'Web no disponible',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.chat,
                                  color: AppColors.primaryColor, size: 40),
                              onPressed: () {
                                // Aquí va la lógica para abrir el chat, que en este caso no está habilitado para esta sección
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.heart_broken,
                                  color: AppColors.primaryColor, size: 40),
                              onPressed: () {
                                User? currentUser =
                                    FirebaseAuth.instance.currentUser;
                                if (currentUser != null) {
                                  String userId = currentUser.uid;
                                  favoritesBusinesses.removeFromFavorites(
                                      userId, businessId);
                                  customToast.showSuccessToast(
                                      "Empresa eliminada de favoritos!");
                                  _updateFavoriteBusinesses();
                                } else {
                                  customToast.showErrorToast(
                                      "Necesitas iniciar sesión para guardar favoritos!");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TindNet"),
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
      ),
      drawer: CustomDrawerCustomer(currentPage: 'Favoritos'),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: favoriteBusinesses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 100,
                    ),
                    Text(
                      'No tienes ninguna empresa guardada en favoritos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: AppColors.primaryColor),
                    ),
                  ],
                ),
              );
            } else {
              List<DocumentSnapshot> businesses = snapshot.data ?? [];
              return ListView.builder(
                itemCount: businesses.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic>? data =
                      businesses[index].data() as Map<String, dynamic>?;
                  return GestureDetector(
                    onTap: () {
                      String businessId = businesses[index]
                          .id;
                      _showCompanyCardDialog(context, data!, businessId);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.business), // Se podría reemplazar esto por un logo o imagen de la empresa
                        title: Text(data?['name'] ?? ''),
                        subtitle: Text(data?['service'] ?? ''),
                        // Podemos seguir añadiendo otros detalles de las empresas
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

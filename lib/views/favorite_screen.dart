import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tindnet/auth/utils/favorites_businesses.dart';
import 'package:tindnet/widgets/custom_toast.dart';
import '../widgets/custom_drawer_customer.dart';
import '../constants/app_colors.dart';

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
                // Aquí va la tarjeta de la empresa
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
                                // Aquí va la lógica para abrir el chat
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
                                  // Manejar el caso en que no hay un usuario autenticado
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
              // return ListView.builder(
              //   itemCount: snapshot.data!.length,
              //   itemBuilder: (context, index) {
              //     Map<String, dynamic> data =
              //         snapshot.data![index].data() as Map<String, dynamic>;
              //     return Card(
              //       child: ListTile(
              //         title: Text(data['name']),
              //         subtitle: Text(data['location']),
              //         // Add more fields as needed
              //       ),
              //     );
              //   },
              // );
              List<DocumentSnapshot> businesses = snapshot.data ?? [];
              return ListView.builder(
                itemCount: businesses.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic>? data =
                      businesses[index].data() as Map<String, dynamic>?;
                  return GestureDetector(
                    onTap: () {
                      String businessId = businesses[index]
                          .id; // Asegúrate de tener el id de la empresa
                      _showCompanyCardDialog(context, data!, businessId);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.business),
                        // Puedes reemplazar esto con un logo o imagen de la empresa
                        title: Text(data?['name'] ?? ''),
                        subtitle: Text(data?['service'] ?? ''),
                        // ... otros detalles del resultado de la búsqueda ...
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

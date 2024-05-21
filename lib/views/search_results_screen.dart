import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/favorites_businesses.dart';
import '../widgets/custom_toast.dart';

/*
/// `SearchResultsScreen` es una clase que muestra una lista de empresas basada en los criterios de búsqueda del usuario.
///
/// Utiliza `FutureBuilder` para obtener las empresas de Firestore y mostrarlas en una lista.
/// Cada elemento de la lista muestra información detallada sobre una empresa, incluyendo su nombre y servicio.
///
/// Los usuarios pueden interactuar con cada elemento de la lista de dos maneras:
/// 1. Pueden ver más detalles sobre la empresa haciendo clic en el elemento de la lista. Esto abrirá un diálogo con más información.
/// 2. Pueden agregar la empresa a sus favoritos haciendo clic en el icono de corazón.
///
/// Esta clase utiliza varios métodos auxiliares:
/// - `getBusinessesByCategory`: Obtiene una lista de todas las empresas de una categoría específica de Firestore.
/// - `getBusinessesByName`: Obtiene una lista de todas las empresas con un nombre específico de Firestore.
/// - `_showCompanyCardDialog`: Muestra un diálogo con más información sobre una empresa.
///
/// El método `build` de esta clase devuelve un `FutureBuilder` que espera que se complete el futuro `getBusinessesByCategory` o `getBusinessesByName`.
/// Dependiendo del estado de este futuro, muestra un spinner de carga, un mensaje de error o una lista de empresas.
 */

class SearchResultsScreen extends StatefulWidget {
  final String selectedCategory;
  final String companyName;

  SearchResultsScreen({this.selectedCategory = '', this.companyName = ''});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  CustomToast customToast = CustomToast();
  FavoritesBusinesses favoritesBusinesses = FavoritesBusinesses();

  Future<List<DocumentSnapshot>> getBusinessesByCategory(
      String category) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('businesses')
        .where('service', isEqualTo: category)
        .get();

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getBusinessesByName(String name) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('businesses')
        .where('name', isEqualTo: name)
        .get();

    return querySnapshot.docs;
  }

  void _showCompanyCardDialog(BuildContext context, Map<String, dynamic> data, String businessId) {
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
                                // Aquí va la lógica para abrir el chat, pero no está implementado en esta sección.
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite,
                                  color: AppColors.primaryColor, size: 40),
                              onPressed: () {
                                User? currentUser = FirebaseAuth.instance.currentUser;
                                if (currentUser != null) {
                                  String userId = currentUser.uid;
                                  favoritesBusinesses.addToFavorites(userId, businessId);
                                  customToast.showSuccessToast("Empresa guardada en favoritos!");
                                } else {
                                  customToast.showErrorToast("Necesitas iniciar sesión para guardar favoritos!");
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
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Resultados de la búsqueda",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: FutureBuilder(
        future: widget.selectedCategory.isNotEmpty
            ? getBusinessesByCategory(widget.selectedCategory)
            : getBusinessesByName(widget.companyName),
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
                      Icons.search_off,
                      color: Colors.grey,
                      size: 100,
                    ),
                    Text(
                      'No se encontraron empresas con los criterios de búsqueda seleccionados',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: AppColors.primaryColor),
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
                      String businessId = businesses[index].id;
                      _showCompanyCardDialog(context, data!, businessId);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.business),
                        title: Text(data?['name'] ?? ''),
                        subtitle: Text(data?['service'] ?? ''),
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

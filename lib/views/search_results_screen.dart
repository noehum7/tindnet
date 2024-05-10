import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/favorites_businesses.dart';
import '../widgets/custom_toast.dart';

class SearchResultsScreen extends StatefulWidget {
  final String selectedCategory;
  final String companyName;

  // SearchResultsScreen({required this.selectedCategory, required this.companyName});
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
                              icon: Icon(Icons.favorite,
                                  color: AppColors.primaryColor, size: 40),
                              onPressed: () {
                                User? currentUser = FirebaseAuth.instance.currentUser;
                                if (currentUser != null) {
                                  String userId = currentUser.uid;
                                  favoritesBusinesses.addToFavorites(userId, businessId);
                                  customToast.showSuccessToast("Empresa guardada en favoritos!");
                                } else {
                                  // Manejar el caso en que no hay un usuario autenticado
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
      // appBar: AppBar(
      //   title: Text("Resultados de la búsqueda"),
      // ),
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
                      String businessId = businesses[index].id; // Asegúrate de tener el id de la empresa
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class SearchResultsScreen extends StatefulWidget {
  final String selectedCategory;
  final String companyName;

  // SearchResultsScreen({required this.selectedCategory, required this.companyName});
  SearchResultsScreen({this.selectedCategory = '', this.companyName = ''});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
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

  AlertDialog buildBusinessDialog(Map<String, dynamic> data) {
    return AlertDialog(
      title: Text(data['name']),
      content: SingleChildScrollView(
        // Añadido SingleChildScrollView
        child: Column(
          children: <Widget>[
            Text('Service: ${data['service']}'),
            // ... otros detalles de la empresa ...
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cerrar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultados de búsqueda"),
      ),
      // body: FutureBuilder(
      //   future: performSearch(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Text('Error: ${snapshot.error}');
      //     } else {
      //       // Asumiendo que performSearch() devuelve una lista de resultados
      //       List<SearchResult> results = snapshot.data;
      //       return ListView.builder(
      //         itemCount: results.length,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             title: Text(results[index].name),
      //             // ... otros detalles del resultado de la búsqueda ...
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),
      // body: FutureBuilder(
      //   future: widget.selectedCategory.isNotEmpty
      //       ? getBusinessesByCategory(widget.selectedCategory)
      //       : getBusinessesByName(widget.companyName),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Text('Error: ${snapshot.error}');
      //     } else {
      //       List<DocumentSnapshot> businesses = snapshot.data ?? [];
      //       return ListView.builder(
      //         itemCount: businesses.length,
      //         itemBuilder: (context, index) {
      //           Map<String, dynamic>? data = businesses[index].data() as Map<String, dynamic>?;
      //           return ListTile(
      //             title: Text(data?['name'] ?? ''),
      //             subtitle: Text(data?['service'] ?? ''),
      //             // ... otros detalles del resultado de la búsqueda ...
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),
      body: FutureBuilder(
        future: widget.selectedCategory.isNotEmpty
            ? getBusinessesByCategory(widget.selectedCategory)
            : getBusinessesByName(widget.companyName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<DocumentSnapshot> businesses = snapshot.data ?? [];
            return ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                Map<String, dynamic>? data =
                    businesses[index].data() as Map<String, dynamic>?;
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return buildBusinessDialog(data!);
                      },
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.business), // Puedes reemplazar esto con un logo o imagen de la empresa
                      title: Text(data?['name'] ?? ''),
                      subtitle: Text(data?['service'] ?? ''),
                      // ... otros detalles del resultado de la búsqueda ...
                    ),
                  ),
//                   child: Card(
//                     color: Colors.transparent,
//                     elevation: 0,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: <Widget>[
//                           Image.network(
//                             data?['url'] ?? 'https://via.placeholder.com/150',
//                             height: MediaQuery.of(context).size.height * 0.25,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             errorBuilder: (BuildContext context,
//                                 Object exception, StackTrace? stackTrace) {
//                               // Si ocurre un error al cargar la imagen, se devuelve una imagen de respaldo
//                               return Image.network(
//                                 'https://via.placeholder.com/150',
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.25,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                               );
//                             },
//                           ),
//                           //En este caso como van a ser url de imágenes usamos network, sino sería asset
//                           SizedBox(height: 10.0),
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               data?['name'] ?? 'Nombre no disponible',
//                               style: TextStyle(
//                                   fontSize: 25.0,
//                                   color: AppColors.primaryColor,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           SizedBox(height: 10.0),
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               data?['aboutUs'] ??
//                                   'Información de la empresa no disponible',
//                               textAlign: TextAlign.left,
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ),
//                           SizedBox(height: 20.0),
//                           Row(
//                             children: <Widget>[
//                               Icon(Icons.work, size: 20),
//                               // Icono de servicios
//                               SizedBox(width: 10.0),
//
//                               Text(data?['service'],
//                                   style: TextStyle(fontSize: 16)),
//                             ],
//                           ),
//                           SizedBox(height: 20.0),
//                           Row(
//                             children: <Widget>[
//                               Icon(Icons.location_on, size: 20),
//                               SizedBox(width: 10.0),
//                               Text(
//                                   data?['location'] ??
//                                       'Ubicación no disponible',
//                                   style: TextStyle(fontSize: 16)),
//                             ],
//                           ),
//                           SizedBox(height: 10.0),
//                           Row(
//                             children: <Widget>[
//                               Icon(Icons.phone, size: 20),
//                               SizedBox(width: 10.0),
//                               Text(data?['phone'] ?? 'Teléfono no disponible',
//                                   style: TextStyle(fontSize: 16)),
//                             ],
//                           ),
//                           SizedBox(height: 10.0),
// //                                Espacio entre los elementos
//                           Row(
//                             children: <Widget>[
//                               Icon(Icons.email, size: 20),
//                               SizedBox(width: 10.0),
//                               Text(data?['email'],
//                                   style: TextStyle(fontSize: 16)),
//                             ],
//                           ),
//                           SizedBox(height: 10.0),
//                           // Espacio entre los elementos
//                           Row(
//                             children: <Widget>[
//                               Icon(Icons.web, size: 20),
//                               SizedBox(width: 10.0),
//                               // Espacio entre los elementos
//                               Text(data?['web'] ?? 'Web no disponible',
//                                   style: TextStyle(fontSize: 16)),
//                             ],
//                           ),
//                           SizedBox(height: 12.0),
//                           // Espacio entre los elementos
//                           Expanded(
//                             child: Container(
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: <Widget>[
//                                   Icon(Icons.chat,
//                                       color: AppColors.primaryColor, size: 40),
//                                   Icon(Icons.favorite,
//                                       color: AppColors.primaryColor, size: 40),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

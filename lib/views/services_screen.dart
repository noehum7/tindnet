import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tindnet/constants/app_colors.dart';
import 'package:tindnet/models/business.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class ServiceScreen extends StatelessWidget {
  final List<Business> businesses;

  // Business business;

  ServiceScreen({required this.businesses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TindNet"),
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.welcomeColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: null,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fondo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.search, color: AppColors.primaryColor),
                title: Text('Búsqueda',
                    style: TextStyle(
                        fontSize: 20.0, color: AppColors.primaryColor)),
                onTap: () {
                  // Navega a la pantalla de búsqueda
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.person, color: AppColors.primaryColor),
                title: Text('Mi Perfil',
                    style: TextStyle(
                        fontSize: 20.0, color: AppColors.primaryColor)),
                onTap: () {
                  // Navega a la pantalla de perfil
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.favorite, color: AppColors.primaryColor),
                title: Text('Favoritas',
                    style: TextStyle(
                        fontSize: 20.0, color: AppColors.primaryColor)),
                onTap: () {
                  // Navega a la pantalla de perfil
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.settings, color: AppColors.primaryColor),
                title: Text('Ajustes',
                    style: TextStyle(
                        fontSize: 20.0, color: AppColors.primaryColor)),
                onTap: () {
                  // Navega a la pantalla de ajustes
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.logout, color: AppColors.primaryColor),
                title: Text('Cerrar sesión',
                    style: TextStyle(
                        fontSize: 20.0, color: AppColors.primaryColor)),
                onTap: () {
                  // Cierra la sesión del usuario
                },
              ),
            ],
          ),
        ),
      ),
      // body: Center(
      //   child: Container(
      //     width: MediaQuery.of(context).size.width * 0.9,
      //     child: Column(
      //       children: <Widget>[
      //         Image.asset(
      //           business.photoUrl,
      //           height: MediaQuery.of(context).size.height * 0.25,
      //           width: double.infinity, //Para coger todo el ancho posible
      //           fit: BoxFit.cover,
      //         ),
      //         SizedBox(height: 10.0),
      //         Align(
      //           alignment: Alignment.centerLeft,
      //         child:
      //           Text(
      //             business.companyName,
      //             style:
      //             TextStyle(fontSize: 25.0, color: AppColors.secondaryColor, fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //         SizedBox(height: 10.0), // Espacio entre los elementos
      //         Row(
      //           children: <Widget>[
      //             Icon(Icons.location_on, size: 20),
      //             Text(business.location, style: TextStyle(fontSize: 18)),
      //           ],
      //         ),
      //         SizedBox(height: 15.0), // Espacio entre los elementos
      //         Align(
      //           alignment: Alignment.centerLeft,
      //           child: Text(
      //             'Sobre nosotros',
      //             style:
      //             TextStyle(fontSize: 25.0, color: AppColors.secondaryColor, fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //         SizedBox(height: 15.0), // Espacio entre los elementos
      //         Align(
      //           alignment: Alignment.centerLeft,
      //           child: Text(
      //             business.aboutUs,
      //             textAlign: TextAlign.left,
      //               style: TextStyle(fontSize: 18)
      //           ),
      //         ),
      //         SizedBox(height: 15.0), // Espacio entre los elementos
      //         Align(
      //           alignment: Alignment.centerLeft,
      //           child: Text(
      //             'Contacto',
      //             style:
      //                 TextStyle(fontSize: 25.0, color: AppColors.secondaryColor, fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //         SizedBox(height: 10.0), // Espacio entre los elementos
      //         Row(
      //           children: <Widget>[
      //             Icon(Icons.phone, size: 20),
      //             SizedBox(width: 10.0),
      //             Text(business.contactPhone, style: TextStyle(fontSize: 18)),
      //           ],
      //         ),
      //         SizedBox(height: 10.0), // Espacio entre los elementos
      //         Row(
      //           children: <Widget>[
      //             Icon(Icons.email, size: 20),
      //             SizedBox(width: 10.0),
      //             Text(business.contactEmail, style: TextStyle(fontSize: 18)),
      //           ],
      //         ),
      //         SizedBox(height: 10.0), // Espacio entre los elementos
      //         Row(
      //           children: <Widget>[
      //             Icon(Icons.web, size: 20),
      //             SizedBox(width: 10.0), // Espacio entre los elementos
      //             Text(business.website, style: TextStyle(fontSize: 18)),
      //           ],
      //         ),
      //         SizedBox(height: 15.0), // Espacio entre los elementos
      //         Expanded(
      //           child: Container(
      //             // height: MediaQuery.of(context).size.height * 0.15,
      //             // decoration: BoxDecoration(
      //             //   color: AppColors.primaryColor, // Color de fondo del contenedor
      //             //   borderRadius: BorderRadius.only(
      //             //     topLeft: Radius.circular(20.0), // Redondea la esquina superior izquierda
      //             //     topRight: Radius.circular(20.0), // Redondea la esquina superior derecha
      //             //   ),
      //             // ),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: <Widget>[
      //                 Icon(Icons.chat, color: AppColors.primaryColor, size: 50),
      //                 Icon(Icons.favorite,
      //                     color: AppColors.primaryColor, size: 50),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: CardSwiper(
            cardsCount: businesses.length,
            cardBuilder: (context, index, realIndex, cardIndex) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // colors: [AppColors.secondaryColor, AppColors.welcomeColor],
                    colors: [Color(0xFFFF0F7B), Color(0xFFF89B29)]
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          businesses[index].photoUrl,
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          //Para coger todo el ancho posible
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            businesses[index].companyName,
                            style: TextStyle(
                                fontSize: 25.0,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     'Sobre nosotros',
                        //     style: TextStyle(
                        //         fontSize: 25.0,
                        //         color: AppColors.secondaryColor,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        // SizedBox(height: 15.0), // Espacio entre los elementos
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            businesses[index].aboutUs,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        // SizedBox(height: 15.0), // Espacio entre los elementos
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     'Contacto',
                        //     style: TextStyle(
                        //         fontSize: 25.0,
                        //         color: AppColors.secondaryColor,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        SizedBox(height: 20.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on, size: 20),
                            SizedBox(width: 10.0),
                            Text(businesses[index].location,
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        // Espacio entre los elementos
                        Row(
                          children: <Widget>[
                            Icon(Icons.phone, size: 20),
                            SizedBox(width: 10.0),
                            Text(businesses[index].contactPhone,
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        // Espacio entre los elementos
                        Row(
                          children: <Widget>[
                            Icon(Icons.email, size: 20),
                            SizedBox(width: 10.0),
                            Text(businesses[index].contactEmail,
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        // Espacio entre los elementos
                        Row(
                          children: <Widget>[
                            Icon(Icons.web, size: 20),
                            SizedBox(width: 10.0),
                            // Espacio entre los elementos
                            Text(businesses[index].website,
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        // Espacio entre los elementos
                        Expanded(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(Icons.chat,
                                    color: AppColors.primaryColor, size: 50),
                                Icon(Icons.favorite,
                                    color: AppColors.primaryColor, size: 50),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

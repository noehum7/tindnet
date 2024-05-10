import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tindnet/constants/app_colors.dart';
import 'package:tindnet/models/business.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tindnet/widgets/custom_toast.dart';
import '../services/favorites_businesses.dart';
import '../widgets/custom_drawer_customer.dart';
import 'chat_screen.dart';
import '../services/chat_service.dart';

class ServiceScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();
  CustomToast customToast = CustomToast();
  FavoritesBusinesses favoritesBusinesses = FavoritesBusinesses();

  Future<List<Business>> getBusinesses() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('businesses').get();
    return querySnapshot.docs.map((doc) => Business.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Business>>(
      future: getBusinesses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return CircularProgressIndicator();
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              strokeWidth: 5.0, //Grosor de la línea
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Business> businesses = snapshot.data!;
          if (businesses.isEmpty) {
            return Center(
              child: Text('No hay empresas disponibles'),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("TindNet"),
                toolbarHeight: MediaQuery.of(context).size.height * 0.07,
              ),
              drawer: CustomDrawerCustomer(currentPage: 'Inicio'),
              body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: CardSwiper(
                    cardsCount: businesses.length,
                    numberOfCardsDisplayed:
                        businesses.length <= 3 ? businesses.length : 3,
                    // Asegúrate de que numberOfCardsDisplayed no exceda cardsCount
                    cardBuilder: (context, index, realIndex, cardIndex) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              // colors: [
                              //   AppColors.welcomeColor,
                              //   AppColors.secondaryColor,
                              // ]),
                              colors: [Color(0xFFf3722c), Color(0xFFf9c74f)]),
                          boxShadow: [ // Sombra para dar profundidad
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // Cambia la posición de la sombra
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  // Image.asset( Si quisiera poner una imagen local del proyecto
                                  Image.network(
                                    businesses[index].url ??
                                        'https://via.placeholder.com/150',
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      // Si ocurre un error al cargar la imagen, se muestra una imagen de respaldo
                                      return Image.asset(
                                        'assets/images/logoblanco.jpg',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10.0),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      businesses[index].name,
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      businesses[index].aboutUs ??
                                          'Información de la empresa no disponible.',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.work,
                                          size: 20,
                                          color: AppColors.primaryColor),
                                      // Icono de servicios
                                      SizedBox(width: 10.0),
                                      Text(businesses[index].service,
                                          style: TextStyle(fontSize: 16,
                                              color: AppColors.primaryColor)),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on,
                                          size: 20,
                                          color: AppColors.primaryColor),
                                      SizedBox(width: 10.0),
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            businesses[index].location ?? 'Dirección no disponible',
                                            style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  //
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.phone,
                                          size: 20,
                                          color: AppColors.primaryColor),
                                      SizedBox(width: 10.0),
                                      Text(
                                          businesses[index].phone ??
                                              'Teléfono no disponible',
                                          style: TextStyle(fontSize: 16, color: AppColors.primaryColor)),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.email,
                                          size: 20,
                                          color: AppColors.primaryColor),
                                      SizedBox(width: 10.0),
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            businesses[index].email,
                                            style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                                          ),
                                        ),
                                      ),
                                      // Text(businesses[index].email,
                                      //     style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.web,
                                          size: 20,
                                          color: AppColors.primaryColor),
                                      SizedBox(width: 10.0),
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            businesses[index].web ?? 'Web no disponible',
                                            style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Container(
                                          padding: EdgeInsets.all(8.0), // Añade un relleno alrededor del icono
                                          decoration: BoxDecoration(
                                            color: Colors.white, // Añade un color de fondo
                                            shape: BoxShape.circle, // Hace que el fondo sea circular
                                          ),
                                          child: Icon(
                                            Icons.chat,
                                            color: AppColors.primaryColor,
                                            size: 40,
                                          ),
                                        ),
                                        onPressed: () {
                                          User? currentUser = FirebaseAuth.instance.currentUser;
                                          if (currentUser != null) {
                                            String userId = currentUser.uid;
                                            String businessId = businesses[index].id; // Asegúrate de tener el id de la empresa
                                            String chatId = '$userId-$businessId'; // Genera un chatId único
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChatScreen(chatId: chatId,
                                                  userId: userId,
                                                  businessId: businessId,
                                                  businessName: businesses[index].name,),
                                              ),
                                            );
                                          } else {
                                            customToast.showErrorToast("Ha ocurrido un error,");
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Container(
                                          padding: EdgeInsets.all(8.0), // Añade un relleno alrededor del icono
                                          decoration: BoxDecoration(
                                            color: Colors.white, // Añade un color de fondo
                                            shape: BoxShape.circle, // Hace que el fondo sea circular
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            color: AppColors.primaryColor,
                                            size: 40,
                                          ),
                                        ),
                                        onPressed: () {
                                          User? currentUser =
                                              FirebaseAuth.instance.currentUser;
                                          if (currentUser != null) {
                                            String userId = currentUser.uid;
                                            String businessId = businesses[
                                                    index]
                                                .id; // Asegúrate de tener el id de la empresa
                                            favoritesBusinesses.addToFavorites(
                                                userId, businessId);
                                            customToast.showSuccessToast(
                                                "Empresa guardada en favoritos!");
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
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}

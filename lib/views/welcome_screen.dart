import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.welcomeColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height *
                  0.5, // Altura del 50% de la pantalla
              child: Image.asset(
                'assets/images/fondo.jpg',
                width: double.infinity, //Para coger todo el ancho posible
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30), // Espacio entre la imagen y el texto
            Container(
              width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80% de la pantalla
              child: Column(
                children: [
                  Text(
                    'Bienvenido a TindNet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                  ),
                  SizedBox(height: 70), // Espacio entre el texto y el botón
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor, // Color de fondo del botón
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'COMENZAR',
                          style: TextStyle(fontSize: 20, color: Colors.white) // Tamaño de la fuente del texto
                        ),
                        SizedBox(width: 50), // Espacio entre el texto y el icono
                        Icon(Icons.arrow_forward, size: 35, color: Colors.white), // Icono de flecha hacia la derecha
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

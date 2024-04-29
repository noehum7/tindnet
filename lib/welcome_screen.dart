import 'package:flutter/material.dart';
import 'app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 50), // Espacio entre la imagen y el texto
            Container(
              width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80% de la pantalla
              child: Column(
                children: [
                  Text(
                    'Bienvenido a TindNet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 70), // Espacio entre el texto y el botón
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Comenzar',
                          style: TextStyle(fontSize: 30, color: AppColors.primaryColor) // Tamaño de la fuente del texto
                        ),
                        SizedBox(width: 50), // Espacio entre el texto y el icono
                        Icon(Icons.arrow_forward, size: 35, color: AppColors.primaryColor), // Icono de flecha hacia la derecha
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

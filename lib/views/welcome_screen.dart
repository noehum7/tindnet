import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/*
 `WelcomeScreen` es una clase que muestra la pantalla de bienvenida de la aplicación.
///
/// Esta pantalla muestra una imagen y un mensaje de bienvenida al usuario. También proporciona un botón para que el usuario pueda comenzar a usar la aplicación.
///
/// Al hacer clic en el botón "COMENZAR", el usuario es redirigido a la pantalla de inicio de sesión.
///
 */

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
                  0.5,
              child: Image.asset(
                'assets/images/fondo.jpg',
                width: double.infinity, //Para coger todo el ancho posible de la pantalla
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Text(
                    'Bienvenido a TindNet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                  ),
                  SizedBox(height: 70),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'COMENZAR',
                          style: TextStyle(fontSize: 20, color: Colors.white)
                        ),
                        SizedBox(width: 50), // Espacio entre el texto y el icono
                        Icon(Icons.arrow_forward, size: 35, color: Colors.white),
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

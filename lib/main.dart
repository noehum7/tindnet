import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tindnet/views/business_screen.dart';
import 'package:tindnet/views/customer_screen.dart';
import 'package:tindnet/views/search_results_screen.dart';
import 'package:tindnet/views/search_screen.dart';
import 'auth/firebase_options.dart';
import 'package:tindnet/views/welcome_screen.dart';
import 'views/login.dart';
import 'package:tindnet/views/customer_registration.dart';
import 'views/business_registration.dart';
import 'constants/app_colors.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TindNet App',
      theme: ThemeData(
        primarySwatch: Colors.blue, //Color de la app
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: TextTheme(
          bodyLarge:
              TextStyle(color: AppColors.primaryColor), //Estilo de los textos
          // labelLarge: TextStyle(color: Colors.white) Estilo de los botones
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primaryColor;
            }
            return null;
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
          ),
          labelStyle: TextStyle(color: AppColors.primaryColor),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primaryColor, // Color del cursor
        ),
      ),
      routes: {
        '/welcome': (context) => WelcomeScreen(), //Pantalla de inicio de la app
        '/login': (context) => LoginScreen(), //Pantalla de login
        '/customer_registration': (context) => CustomerRegistrationScreen(), //Pantalla de registro de clientes
        '/business_registration': (context) => BusinessRegistrationScreen(), //Pantalla de registro de empresas
        '/services': (context) => ServiceScreen(), //Pantalla principal de los clientes, que te muestra las empresas tipo Tinder
        '/business': (context) => BusinessProfileScreen(), //Pantalla principal de las empresas
        '/search': (context) => SearchScreen(), //Pantalla de búsqueda de servicios
        '/search_results': (context) => SearchResultsScreen(), //Pantalla de resultados de búsqueda
      },
      home:
          WelcomeScreen(), // Se ha establecido WelcomeScreen como página de inicio de la app
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tindnet/views/home.dart';
import 'package:tindnet/views/services_screen.dart';
import 'auth/firebase_options.dart';
import 'package:tindnet/views/welcome_screen.dart';
import 'models/business.dart';
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
        primarySwatch: Colors.blue,
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
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/customer_registration': (context) => CustomerRegistrationScreen(),
        '/business_registration': (context) => BusinessRegistrationScreen(),
        // '/home': (context) => HomeScreen(),
        '/services': (context) => ServiceScreen(
              businesses: [
                Business(
                    photoUrl: 'assets/images/urbansport.png',
                    companyName: 'UrbanSport',
                    location: 'Málaga',
                    aboutUs: 'Somos una tienda de deportes multimarca.',
                    contactPhone: '123456789',
                    contactEmail: 'urbansport@gmail.com',
                    website: 'www.urbansport.es'),
                Business(
                  photoUrl: 'assets/images/logoazul.jpg',
                  companyName: 'Otra Empresa',
                  location: 'Sevilla',
                  aboutUs: 'Somos una empresa de tecnología.',
                  contactPhone: '987654321',
                  contactEmail: 'otraempresa@gmail.com',
                  website: 'www.otraempresa.es',
                ),
                // Añade aquí más empresas
              ],
            ),
      },
      home:
          WelcomeScreen(), // Se ha establecido WelcomeScreen como página principal
    );
  }
}

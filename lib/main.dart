import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'welcome_screen.dart';
import 'login.dart';
import 'customer_registration.dart';
import 'business_registration.dart';
import 'app_colors.dart';

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
            bodyLarge: TextStyle(color: AppColors.primaryColor), //Estilo de los textos
          // labelLarge: TextStyle(color: Colors.white) Estilo de los botones
        )
      ),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/customer_registration': (context) => CustomerRegistrationScreen(),
        '/business_registration': (context) => BusinessRegistrationScreen(),
      },
      home:
          WelcomeScreen(), // Se ha establecido WelcomeScreen como página principal
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title; // Título de la página principal
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Text(
//           'Bienvenido a TindNet App',
//           style: TextStyle(fontSize: 24.0),
//         ),
//       ),
//     );
//   }
// }

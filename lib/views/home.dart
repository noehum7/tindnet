// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'login.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String? userName;
//   final _auth = FirebaseAuth.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserName();
//   }
//
//   fetchUserName() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       setState(() {
//         userName = docSnapshot['name'];
//       });
//     }
//   }
//
//   Future<void> forgetUser() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('userId');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bienvenido'),
//         automaticallyImplyLeading: false, //Para quitar la flecha atrás
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Hola,',
//               style: TextStyle(fontSize: 24),
//             ),
//             Text(
//              userName ?? 'Usuario',
//               style: TextStyle(fontSize: 24),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await _auth.signOut();
//                 await forgetUser();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               },
//               child: Text('Cerrar sesión'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
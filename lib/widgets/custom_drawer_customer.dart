import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tindnet/constants/app_colors.dart';
import 'package:tindnet/widgets/custom_toast.dart';

import '../views/login.dart';

class CustomDrawerCustomer extends StatelessWidget {
  final String currentPage;
  CustomToast customToast = CustomToast();

  Future<void> forgetUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  CustomDrawerCustomer({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              leading: Icon(Icons.home, color: currentPage == 'Inicio' ? AppColors.backgroundColor : AppColors.primaryColor),
              title: Text('Inicio',
                  style: TextStyle(
                      fontSize: 20.0, color: currentPage == 'Inicio' ? AppColors.backgroundColor : AppColors.primaryColor)),
              onTap: () {
                Navigator.pushNamed(context, '/services');
              },
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.search, color: currentPage == 'Búsqueda' ? AppColors.backgroundColor : AppColors.primaryColor),
              title: Text('Búsqueda',
                  style: TextStyle(
                      fontSize: 20.0, color: currentPage == 'Búsqueda' ? AppColors.backgroundColor : AppColors.primaryColor)),
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.favorite, color: currentPage == 'Favoritos' ? AppColors.backgroundColor : AppColors.primaryColor),
              title: Text('Favoritos',
                  style: TextStyle(
                      fontSize: 20.0, color: currentPage == 'Favoritos' ? AppColors.backgroundColor : AppColors.primaryColor)),
              onTap: () {
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.chat_bubble, color: currentPage == 'Chats' ? AppColors.backgroundColor : AppColors.primaryColor),
              title: Text('Chats',
                  style: TextStyle(
                      fontSize: 20.0, color: currentPage == 'Chats' ? AppColors.backgroundColor : AppColors.primaryColor)),
              onTap: () {
                Navigator.pushNamed(context, '/chat_list');
              },
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.person, color: currentPage == 'Mi Perfil' ? AppColors.backgroundColor : AppColors.primaryColor),
              title: Text('Mi Perfil',
                  style: TextStyle(
                      fontSize: 20.0, color: currentPage == 'Mi Perfil' ? AppColors.backgroundColor : AppColors.primaryColor)),
              onTap: () {
                // Navigator.pushNamed(context, '/profile_screen');
              },
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.settings, color: currentPage == 'Ajustes' ? AppColors.backgroundColor : AppColors.primaryColor),
              title: Text('Ajustes',
                  style: TextStyle(
                      fontSize: 20.0, color: currentPage == 'Ajustes' ? AppColors.backgroundColor : AppColors.primaryColor)),
              onTap: () {
                // Navigator.pushNamed(context, '/settings_screen');
              },
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.primaryColor),
              title: Text('Cerrar sesión',
                  style: TextStyle(
                      fontSize: 20.0, color: AppColors.primaryColor)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await forgetUser();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginScreen()),
                // );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                );
                customToast.showSuccessToast("Has cerrado sesión!");
              },
            ),
          ],
        ),
      ),
    );
  }
}
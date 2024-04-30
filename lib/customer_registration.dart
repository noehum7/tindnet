import 'package:flutter/material.dart';
import 'app_colors.dart';

class CustomerRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Únete a nosotros',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                height: 2.0,
                width: MediaQuery.of(context).size.width * 0.8,
                color: AppColors.secondaryColor,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/business_registration');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Eres una empresa? Pulsa aquí',
                      style: TextStyle(
                          fontSize: 15, color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                // height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38.0),
                    color: Colors.white),
                child: Column(
                  children: [
                    Text(
                      'REGISTRO CLIENTES',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                      ),
                    ),
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () {
                        // Acción a realizar cuando se presiona el botón de registrarse
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryColor, // Color de fondo
                      ),
                      child: Text(
                        'REGISTRARSE',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  '¿Ya tienes una cuenta? Inicia sesión',
                  style: TextStyle(fontSize: 15, color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
          // ),
        ),
      ),
    ));
  }
}

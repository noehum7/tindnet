import 'package:flutter/material.dart';
import 'app_colors.dart';

class BusinessRegistrationScreen extends StatelessWidget {
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
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 2.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: AppColors.secondaryColor,
                ),
                SizedBox(height: 40.0),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38.0),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Text(
                        'REGISTRO EMPRESAS',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Nombre o razón social',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'CIF',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Servicio',
                        ),
                        items: <String>['Opción 1', 'Opción 2', 'Opción 3']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Acción a realizar cuando se selecciona una opción del menú desplegable
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 40.0),
                      ElevatedButton(
                        onPressed: () {
                          // Acción a realizar cuando se presiona el botón de registrarse
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                        child: Text('REGISTRARSE',
                          style: TextStyle(fontSize: 18, color: Colors.white),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
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
          ),
        ),
      ),
    );
  }
}

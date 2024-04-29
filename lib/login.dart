import 'package:flutter/material.dart';
import 'app_colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Container(
                height: 2.0,
                width: MediaQuery.of(context).size.width * 0.8,
                color: AppColors.secondaryColor,
              ),
              Image.asset(
                'assets/images/logoazul.jpg',
                width: 250,
                height: 200,
              ),
              SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true, // Oculta el texto de la contraseña
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        Text('Recuérdame'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Acción a realizar cuando se presiona el botón de iniciar sesión
                },
                child: Text('Iniciar Sesión'),
              ),
              SizedBox(height: 10.0),
              Text("o"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/customer_registration');
                },
                child: Text('Crear cuenta'),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  // Acción a realizar cuando se presiona el texto de "¿Has olvidado la contraseña?"
                },
                child: Text('¿Has olvidado la contraseña?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

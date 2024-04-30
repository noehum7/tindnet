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
              SizedBox(height: 20.0),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: Icon(Icons.visibility),
                      ),
                      obscureText: true,
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
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Acción a realizar cuando se presiona el botón de iniciar sesión
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor, // Color de fondo del botón
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Iniciar sesión', style: TextStyle(fontSize: 20, color: Colors.white)),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 2.0,
                          width: MediaQuery.of(context).size.width * 0.35,
                          color: AppColors.secondaryColor,
                        ),
                        SizedBox(width: 10), // Espacio entre las líneas y el texto "o"
                        Text("o", style: TextStyle(fontSize: 15)),
                        SizedBox(width: 10), // Espacio entre las líneas y el texto "o"
                        Container(
                          height: 2.0,
                          width: MediaQuery.of(context).size.width * 0.35,
                          color: AppColors.secondaryColor,
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/customer_registration');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Crear cuenta', style: TextStyle(fontSize: 18, color: AppColors.primaryColor)),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextButton(
                      onPressed: () {
                        // Acción a realizar cuando se presiona el texto de "¿Has olvidado la contraseña?"
                      },
                      child: Text('¿Has olvidado la contraseña?', style: TextStyle(fontSize: 15, color: AppColors.primaryColor)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

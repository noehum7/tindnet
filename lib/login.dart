import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:get/get.dart';
import 'package:tindnet/auth/utils/validators_utils.dart';

// import 'package:flutter_with_firebase_owp/auth/structure/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  final FormValidator formValidator = FormValidator();

  // Define an instance of FirebaseAuth
  final _auth = FirebaseAuth.instance;

  // Define the controllers for the email and password fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
                      TextFormField(
                        controller: _emailController,
                        validator: formValidator.isValidEmail,
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
                      TextFormField(
                        controller: _passwordController,
                        validator: formValidator.isValidPass,
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
                        onPressed: () async{
                          // if (_formKey.currentState!.validate()) {
                          //   // authController.loginWithEmailAndPassword();
                          //   print("Correcto");
                          // } else {
                          //   print("vuelve a intentarlo");
                          // }
                          try {
                            UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            print("User signed in: ${userCredential.user}");

                            // Show a success message
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Usuario correcto, has accedido'))
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('No user found for that email.'))
                              );
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Wrong password provided for that user.'))
                              );
                            }
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString()))
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .primaryColor, // Color de fondo del botón
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Iniciar sesión',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
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
                          SizedBox(width: 10),
                          // Espacio entre las líneas y el texto "o"
                          Text("o", style: TextStyle(fontSize: 15)),
                          SizedBox(width: 10),
                          // Espacio entre las líneas y el texto "o"
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
                          Navigator.pushNamed(
                              context, '/customer_registration');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Crear cuenta',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryColor)),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0),
                      TextButton(
                        onPressed: () {
                          // Acción a realizar cuando se presiona el texto de "¿Has olvidado la contraseña?"
                        },
                        child: Text('¿Has olvidado la contraseña?',
                            style: TextStyle(
                                fontSize: 15, color: AppColors.primaryColor)),
                      ),
                    ],
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

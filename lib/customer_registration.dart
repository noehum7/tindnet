import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'app_colors.dart';
import 'package:tindnet/auth/utils/validators_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerRegistrationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FormValidator formValidator = FormValidator();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
      // Hace que el SnackBar flote
      shape: RoundedRectangleBorder(
        // Le da una forma redondeada
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: AppColors.primaryColor,
      elevation: 5.0, // Añade una sombra al SnackBar
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
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
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/business_registration');
                    },
                    child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿Eres una empresa? Pulsa aquí',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.primaryColor),
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
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          controller: _nameController,
                          validator: formValidator.isValidName,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _emailController,
                          validator: formValidator.isValidEmail,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          validator: formValidator.isValidPass,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            errorMaxLines: 2,
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _phoneController,
                          validator: formValidator.isValidPhone,
                          decoration: InputDecoration(
                            labelText: 'Teléfono',
                            errorMaxLines: 2,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                UserCredential userCredential =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                print(
                                    "User registered: ${userCredential.user}");
                                showSnackBar(context, 'Usuario registrado correctamente.');
                                // Save user data to Firestore
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userCredential.user!.uid)
                                    .set({
                                  'email': _emailController.text,
                                  'name': _nameController.text,
                                  'phone': _phoneController.text,
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  print('The password provided is too weak.');
                                  showSnackBar(context, 'La contraseña es demasiado débil.');
                                } else if (e.code == 'email-already-in-use') {
                                  print(
                                      'The account already exists for that email.');
                                  showSnackBar(context, 'El email ya está en uso.');
                                }
                              } catch (e) {
                                print(e);
                                showSnackBar(context, e.toString());
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryColor, // Color de fondo
                          ),
                          child: Text(
                            'REGISTRARSE',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
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
                      style: TextStyle(
                          fontSize: 10, color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}

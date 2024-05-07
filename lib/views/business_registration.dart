import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../auth/utils/validators_utils.dart';
import '../widgets/custom_toast.dart';

class BusinessRegistrationScreen extends StatefulWidget {
  @override
  _BusinessRegistrationScreenState createState() => _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState extends State<BusinessRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  CustomToast customToast = CustomToast();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FormValidator formValidator = FormValidator();

  final _nameController = TextEditingController();
  final _cifController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Form(
              key: _formKey,
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
                              fontSize: 18.0, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          controller: _nameController,
                          validator: formValidator.isValidName,
                          decoration: InputDecoration(
                            labelText: 'Nombre o razón social',
                            filled: true,
                            fillColor: AppColors.welcomeColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _cifController,
                          validator: formValidator.isValidCif,
                          decoration: InputDecoration(
                            labelText: 'CIF',
                            filled: true,
                            fillColor: AppColors.welcomeColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _emailController,
                          validator: formValidator.isValidEmail,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: AppColors.welcomeColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        DropdownButtonFormField(
                          validator: formValidator.isValidService,
                          decoration: InputDecoration(
                            labelText: 'Servicios',
                            filled: true,
                            fillColor: AppColors.welcomeColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: <String>[
                            'Productos',
                            'Viajes',
                            'Eventos',
                            'Ocio',
                            'Restauración',
                            'Otros'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedService = newValue;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          validator: formValidator.isValidPass,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            errorMaxLines: 2,
                            filled: true,
                            fillColor: AppColors.welcomeColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 40.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                UserCredential userCredential =
                                await _auth.createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                                // print("Business registered: ${userCredential.user}");
                                customToast.showSuccessToast("Empresa registrada correctamente!");
                                // Save business data to Firestore
                                await FirebaseFirestore.instance
                                    .collection('businesses')
                                    .doc(userCredential.user!.uid)
                                    .set({
                                  'email': _emailController.text,
                                  'name': _nameController.text,
                                  'cif': _cifController.text,
                                  'service': _selectedService,
                                });

                                Navigator.pushReplacementNamed(context, '/business'); //Redirigir si el registro es exitoso
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  customToast.showErrorToast('La contraseña es demasiado débil.');
                                } else if (e.code == 'email-already-in-use') {
                                  customToast.showErrorToast('El email ya está en uso.');
                                }
                              } catch (e) {
                                customToast.showInfoToast(e.toString());
                              }
                            }

                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor),
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
            ),
          ),
        ),
      ),
    );
  }
}

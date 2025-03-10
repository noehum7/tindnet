import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tindnet/views/customer_screen.dart';
import '../constants/app_colors.dart';
import '../utils/validators_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_toast.dart';
import 'business_screen.dart';

/*
/// `LoginScreen` es una clase que proporciona una interfaz para que los usuarios inicien sesión en la aplicación.
///
/// Utiliza `FirebaseAuth` para autenticar a los usuarios con su correo electrónico y contraseña.
/// Si el inicio de sesión es exitoso, redirige al usuario a la pantalla de cliente o de empresa.
///
/// Los usuarios pueden optar por recordar su inicio de sesión. Si eligen hacerlo, su ID de usuario se guarda en `SharedPreferences` y se utiliza para iniciar sesión automáticamente la próxima vez que abran la aplicación. Implementado para empresas y clientes.
///
/// Esta clase utiliza varios métodos auxiliares:
/// - `rememberUser`: Guarda el ID de usuario en `SharedPreferences`.
/// - `checkRememberedUser`: Comprueba si hay un ID de usuario guardado en `SharedPreferences` y, si lo hay, inicia sesión automáticamente.
/// - `_togglePasswordVisibility`: Cambia la visibilidad de la contraseña en el campo de texto de la contraseña.
///
/// El método `build` de esta clase devuelve un formulario que los usuarios pueden rellenar para iniciar sesión. Si el formulario es válido, intenta iniciar sesión con `FirebaseAuth`. Si el inicio de sesión es exitoso, redirige al usuario a la pantalla de cliente o de empresa.
 */

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool _isPasswordHidden = true;
  CustomToast customToast = CustomToast();

  final _formKey = GlobalKey<FormState>();
  final FormValidator formValidator = FormValidator();
  final _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  Future<void> rememberUser(UserCredential userCredential) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userCredential.user!.uid);
  }

  Future<void> checkRememberedUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Si el usuario existe en la tabla de usuarios, redirige a la pantalla de cliente
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ServiceScreen()),
        );
      } else {
        // Si el usuario no existe en la tabla de usuarios, asume que es una empresa y redirige a la pantalla de empresa
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BusinessProfileScreen()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkRememberedUser();
  }

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
                          prefixIcon: Icon(Icons.person),
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
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.secondaryColor,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        obscureText: _isPasswordHidden,
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
                        onPressed: () async {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            customToast.showInfoToast(
                                'Por favor, rellene todos los campos.');
                            return;
                          }
                          try {
                            UserCredential userCredential =
                                await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            customToast.showSuccessToast("Login correcto!");

                            if (rememberMe) {
                              await rememberUser(userCredential);
                            }

                            String userId = userCredential.user!.uid;
                            DocumentSnapshot userDoc = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(userId)
                                .get();

                            if (userDoc.exists) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServiceScreen()),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BusinessProfileScreen()),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-credential') {
                              customToast.showErrorToast(
                                  'El correo electrónico o la contraseña no son correctos.');
                            }
                          } catch (e) {
                            customToast.showInfoToast(e.toString());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .primaryColor,
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
                          Text("o", style: TextStyle(fontSize: 15)),
                          SizedBox(width: 10),
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
                          // Acción a realizar cuando se presiona el texto de "¿Has olvidado la contraseña?", no está implementado aún!!
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

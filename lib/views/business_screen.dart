import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/validators_utils.dart';
import 'package:tindnet/widgets/custom_drawer_business.dart';
import 'package:tindnet/widgets/custom_toast.dart';
import '../constants/app_colors.dart';
import '../models/business.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
 * `BusinessProfileScreen` es una clase que representa la pantalla de perfil de una empresa.
 *
 * Esta pantalla muestra la información de la empresa que está actualmente autenticada.
 * La información se recupera de Firestore y se muestra en varios campos de texto.
 * Los campos de texto son editables, lo que permite a la empresa actualizar su información.
 * La pantalla también muestra una imagen de perfil de la empresa, que se puede actualizar.
 *
 * Al presionar el botón 'Guardar cambios', se validan los datos introducidos y, si son válidos,
 * se actualizan en Firestore. Si la validación falla, se muestran mensajes de error.
 *
 * Esta clase utiliza `FormValidator` para la validación de los datos introducidos.
 *
 */

class BusinessProfileScreen extends StatefulWidget {
  @override
  _BusinessProfileScreenState createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FormValidator _validator = FormValidator();
  CustomToast customToast = CustomToast();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String businessId = FirebaseAuth.instance.currentUser!.uid;

  Business? business;

  @override
  void initState() {
    super.initState();
    getBusinessData();
  }

  Future<void> getBusinessData() async {
    DocumentSnapshot doc =
        await _firestore.collection('businesses').doc(businessId).get();
    // return Business.fromDocument(doc);
    setState(() {
      business = Business.fromDocument(doc);
    });
  }

  Future<void> updateBusinessData(Business business) {
    return _firestore
        .collection('businesses')
        .doc(businessId)
        .update(business.toDocument());
  }

  @override
  Widget build(BuildContext context) {
    if (business == null) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("TindNet"),
          toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        ),
        drawer: CustomDrawerBusiness(currentPage: 'Mi Perfil'),
        body: business == null
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Text('Mi Perfil',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            SizedBox(height: 20.0),
                            Image.network(
                              business?.url ??
                                  'https://via.placeholder.com/150',
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 30.0),
                            TextFormField(
                              initialValue: business?.name,
                              validator: _validator.isValidName,
                              decoration: InputDecoration(
                                labelText: 'Nombre o razón social',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                errorMaxLines: 2,
                                filled: true,
                                fillColor: AppColors.welcomeColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.business),
                              ),
                              onChanged: (value) => business?.name = value,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: business?.cif,
                              validator: _validator.isValidCif,
                              decoration: InputDecoration(
                                labelText: 'CIF',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                errorMaxLines: 2,
                                filled: true,
                                fillColor: AppColors.welcomeColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.numbers),
                              ),
                              onChanged: (value) => business?.cif = value,
                            ),
                            SizedBox(height: 20.0),
                            DropdownButtonFormField(
                              value: business?.service,
                              validator: _validator.isValidService,
                              items: [
                                'Productos',
                                'Viajes',
                                'Eventos',
                                'Ocio',
                                'Restauración',
                                'Otros'
                              ]
                                  .map((service) => DropdownMenuItem(
                                        child: Text(service),
                                        value: service,
                                      ))
                                  .toList(),
                              decoration: InputDecoration(
                                labelText: 'Servicio',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                errorMaxLines: 2,
                                filled: true,
                                fillColor: AppColors.welcomeColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.home_repair_service),
                              ),
                              onChanged: (value) => business?.service = value!,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: business?.phone,
                              validator: _validator.isValidPhone,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Teléfono',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                errorMaxLines: 2,
                                filled: true,
                                fillColor: AppColors.welcomeColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.phone_android),
                              ),
                              onChanged: (value) => business?.phone = value,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: business?.url,
                              validator: _validator.isValidUrl,
                              decoration: InputDecoration(
                                labelText: 'Imagen de perfil',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                errorMaxLines: 2,
                                filled: true,
                                fillColor: AppColors.welcomeColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.image),
                              ),
                              onChanged: (value) => business?.url = value,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: business?.location,
                              validator: _validator.isValidLocation,
                              decoration: InputDecoration(
                                labelText: 'Dirección de la empresa',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                errorMaxLines: 2,
                                filled: true,
                                fillColor: AppColors.welcomeColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.location_on_outlined),
                              ),
                              onChanged: (value) => business?.location = value,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: business?.aboutUs,
                              validator: _validator.isValidAboutUs,
                              decoration: InputDecoration(
                                labelText: 'Sobre nosotros',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                errorMaxLines: 2,
                                filled: true,
                                fillColor: AppColors.welcomeColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.info_outline),
                              ),
                              onChanged: (value) => business?.aboutUs = value,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: business?.web,
                              validator: _validator.isValidWeb,
                              decoration: InputDecoration(
                                labelText: 'Página web de la empresa',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                errorMaxLines: 2,
                                filled: true,
                                fillColor: AppColors.welcomeColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.web),
                              ),
                              onChanged: (value) => business?.web = value,
                            ),
                            SizedBox(height: 30.0),
                            ElevatedButton(
                              child: Text('Guardar cambios',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryColor)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  updateBusinessData(business!);
                                  customToast.showSuccessToast(
                                      'Cambios guardados correctamente!');
                                }
                              },
                            ),
                          ],
                        )),
                  ),
                ),
              ),
      );
    }
  }
}

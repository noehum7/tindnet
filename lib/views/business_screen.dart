import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tindnet/auth/utils/validators_utils.dart';
import 'package:tindnet/widgets/custom_drawer_business.dart';
import '../constants/app_colors.dart';
import '../models/business.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
Pantalla principal cuando una empresa se loguea.
 */

class BusinessProfileScreen extends StatefulWidget {
  @override
  _BusinessProfileScreenState createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FormValidator _validator = FormValidator();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtiene el ID del usuario actualmente autenticado
  final String businessId = FirebaseAuth.instance.currentUser!.uid;

  // late Business business;
  Business? business;

  @override
  void initState() {
    super.initState();
    getBusinessData();
  }

  // Future<Business> getBusinessData() async { //He cambiado esto
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
          toolbarHeight: MediaQuery
              .of(context)
              .size
              .height * 0.07,
        ),
        drawer: CustomDrawerBusiness(currentPage: 'Mi Perfil'),
        // body: FutureBuilder<Business>(
        //   future: getBusinessData(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return CircularProgressIndicator();
        //     } else if (snapshot.hasError) {
        //       return Text('Error: ${snapshot.error}');
        //     } else {
        //       Business business = snapshot.data!;
        //       // business = snapshot.data!;
        //       return SingleChildScrollView(
        body: business == null
            ? CircularProgressIndicator()
            : SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery
                  .of(context)
                  .size
                  .height,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    // ListView
                    // padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      Text('Mi Perfil',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      SizedBox(height: 20.0),
                      TextFormField(
                        initialValue: business?.name,
                        validator: _validator.isValidName,
                        decoration: InputDecoration(
                            labelText: 'Nombre o razón social'
                            ,errorMaxLines: 2),
                        onChanged: (value) => business?.name = value,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        initialValue: business?.cif,
                        validator: _validator.isValidCif,
                        decoration: InputDecoration(labelText: 'CIF', errorMaxLines: 2),
                        onChanged: (value) => business?.cif = value,
                      ),
                      SizedBox(height: 10.0),
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
                        ].map((service) =>
                            DropdownMenuItem(
                              child: Text(service),
                              value: service,
                            ))
                            .toList(),
                        decoration: InputDecoration(
                            labelText: 'Servicio', errorMaxLines: 2),
                        onChanged: (value) => business?.service = value!,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        initialValue: business?.phone,
                        validator: _validator.isValidPhone,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Teléfono', errorMaxLines: 2),
                        onChanged: (value) => business?.phone = value,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        initialValue: business?.url,
                        validator: _validator.isValidUrl,
                        decoration:
                        InputDecoration(labelText: 'Imagen de perfil', errorMaxLines: 2),
                        onChanged: (value) => business?.url = value,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        initialValue: business?.location,
                        validator: _validator.isValidLocation,
                        decoration: InputDecoration(
                            labelText: 'Dirección de la empresa', errorMaxLines: 2),
                        onChanged: (value) => business?.location = value,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        initialValue: business?.aboutUs,
                        validator: _validator.isValidAboutUs,
                        decoration:
                        InputDecoration(labelText: 'Sobre nosotros', errorMaxLines: 2),
                        // maxLines: 2,
                        // validator: (value) {
                        //   if (value != null && value.split(' ').length > 30) {
                        //     return 'Por favor, introduce un máximo de 30 palabras.';
                        //   }
                        //   return null;
                        // },
                        onChanged: (value) => business?.aboutUs = value,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        initialValue: business?.web,
                        validator: _validator.isValidWeb,
                        decoration: InputDecoration(
                            labelText: 'Página web de la empresa'),
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
                          }
                        },
                      ),
                    ],
//                         )),
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       );
//   }
// }
                  )),
            ),
          ),
        ),
      );
    }
  }
}

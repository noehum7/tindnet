import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import '../services/image_handler_service.dart';
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
  final ImageHandler _imageHandler = ImageHandler();
  final String businessId = FirebaseAuth.instance.currentUser!.uid;
  Business? business;
  List<String> selectedImages = [];

  Future<void> updateBusinessImages() async {
    try {
      List<File> images = await _imageHandler.selectMultipleImages();
      if (images.length > 3) {
        customToast.showErrorToast('Solo puedes subir un máximo de 3 imágenes.');
        return;
      }
      List<String> imageUrls = [];
      for (var image in images) {
        String imageUrl = await _imageHandler.uploadImage(image);
        imageUrls.add(imageUrl);
      }
      // Añadir las nuevas imágenes a la lista existente
      if (business?.images != null) {
        if (business!.images!.length + imageUrls.length > 3) {
          customToast.showErrorToast('Solo puedes tener un máximo de 3 imágenes.');
          return;
        }
        business?.images?.addAll(imageUrls);
      } else {
        if (imageUrls.length > 3) {
          customToast.showErrorToast('Solo puedes tener un máximo de 3 imágenes.');
          return;
        }
        business?.images = imageUrls;
      }
      await updateBusinessData(business!);
      customToast.showSuccessToast("Imágenes actualizadas correctamente!");
      setState(() {}); // Actualizar el estado para refrescar el GridView
    } catch (e) {
      // Manejar errores
    }
  }

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
                            // Image.network(
                            //   business?.url ??
                            //       'https://via.placeholder.com/150',
                            //   height: MediaQuery.of(context).size.height * 0.25,
                            //   width: double.infinity,
                            //   fit: BoxFit.cover,
                            // ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: double.infinity,
                              child: PageView.builder(
                                itemCount: business?.images?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Image.network(business!.images?[index] ?? 'https://via.placeholder.com/150',
                                  fit: BoxFit.cover);
                                },
                              ),
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
                            // TextFormField(
                            //   initialValue: business?.url,
                            //   validator: _validator.isValidUrl,
                            //   decoration: InputDecoration(
                            //     labelText: 'Imagen de perfil',
                            //     labelStyle:
                            //         TextStyle(fontWeight: FontWeight.bold),
                            //     errorMaxLines: 2,
                            //     filled: true,
                            //     fillColor: AppColors.welcomeColor,
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //       borderSide: BorderSide.none,
                            //     ),
                            //     prefixIcon: Icon(Icons.image),
                            //   ),
                            //   onChanged: (value) => business?.url = value,
                            // ),
                            // ElevatedButton( ESTO ERA LO QUE FUNCIONABA
                            //   child: Text('Seleccionar imagen de perfil',
                            //       style: TextStyle(
                            //           fontSize: 18,
                            //           color: AppColors.primaryColor)),
                            //   onPressed: () async {
                            //     try {
                            //       File image = await _imageHandler.selectImage();
                            //       String imageUrl = await _imageHandler.uploadImage(image);
                            //       if (business?.images == null) {
                            //         business?.images = [imageUrl];
                            //       } else {
                            //         business?.images?.add(imageUrl);
                            //       }
                            //       await updateBusinessData(business!);
                            //       customToast.showSuccessToast('Imagen de perfil actualizada correctamente!');
                            //     } catch (e) {
                            //       // Manejar errores
                            //     }
                            //   },
                            // ),
                            // ...
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(text: 'Seleccionar imagen de perfil'),
                              decoration: InputDecoration(
                                labelText: 'Imagen de perfil',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                filled: true,
                                fillColor: AppColors.welcomeColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.image),
                              ),
                              // onTap: () async {
                              //   try {
                              //     List<File> images = await _imageHandler.selectMultipleImages();
                              //     if (business?.images != null && business!.images!.length + images.length > 3) {
                              //       customToast.showErrorToast('Solo puedes tener un máximo de 3 imágenes.');
                              //       return;
                              //     }
                              //     List<String> imageUrls = [];
                              //     for (var image in images) {
                              //       String imageUrl = await _imageHandler.uploadImage(image);
                              //       imageUrls.add(imageUrl);
                              //     }
                              //
                              //     if (business?.images == null) {
                              //       business?.images = imageUrls;
                              //     } else {
                              //       business?.images?.addAll(imageUrls);
                              //     }
                              //
                              //     await updateBusinessData(business!);
                              //     customToast.showSuccessToast('Imagen de perfil actualizada correctamente!');
                              //     setState(() {}); // Actualizar el estado para refrescar el GridView
                              //   } catch (e) {
                              //     // Manejar errores
                              //   }
                              // },
                              onTap: () async {
                                try {
                                  if (business?.images != null && business!.images!.length + selectedImages.length >= 3) {
                                    customToast.showErrorToast('Ya has alcanzado el máximo de 3 imágenes.');
                                    return;
                                  }
                                  List<File> images = await _imageHandler.selectMultipleImages();
                                  if (business?.images != null && business!.images!.length + selectedImages.length + images.length > 3) {
                                    customToast.showErrorToast('Seleccionar estas imágenes superaría el máximo de 3 imágenes.');
                                    return;
                                  }
                                  for (var image in images) {
                                    String imageUrl = await _imageHandler.uploadImage(image);
                                    selectedImages.add(imageUrl);
                                  }
                                  setState(() {}); // Actualizar el estado para refrescar el GridView
                                } catch (e) {
                                  // Manejar errores
                                }
                              },
                            ),
                            SizedBox(height: 20.0),
                            // business?.images != null && business!.images!.isNotEmpty
                            // ? GridView.count(
                            //   shrinkWrap: true,
                            //   crossAxisCount: 3,
                            //   children: List.generate(business!.images!.length, (index) {
                            //     return Stack(
                            //       // alignment: Alignment.topRight,
                            //       children: <Widget>[
                            //         Container(
                            //           width: 100, // Ancho fijo
                            //           height: 100, // Altura fija
                            //           child: Image.network(
                            //             business!.images![index],
                            //             fit: BoxFit.cover,
                            //           ),
                            //         ),
                            //         Positioned(
                            //           top: -17.0, // Posición desde la parte superior
                            //           right: 1.0, // Posición desde la derecha
                            //           child: IconButton(
                            //             icon: Icon(
                            //               Icons.close,
                            //               color: Colors.red,
                            //             ),
                            //             onPressed: () async {
                            //               // Eliminar la imagen de la lista
                            //               String imageUrl = business!.images!.removeAt(index);
                            //               // Actualizar la base de datos
                            //               await updateBusinessData(business!);
                            //               // Eliminar la imagen del almacenamiento en la nube
                            //               await _imageHandler.deleteImage(imageUrl);
                            //               // Actualizar el estado para refrescar el GridView
                            //               setState(() {});
                            //               customToast.showSuccessToast('Imagen eliminada correctamente!');
                            //             },
                            //           ),
                            //         ),
                            //       ],
                            //     );
                            //   }),
                            // )
                            //     : Container(),
                            business?.images != null && (business!.images!.isNotEmpty || selectedImages.isNotEmpty)
                                ? GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              children: List.generate(business!.images!.length + selectedImages.length, (index) {
                                String imageUrl = index < business!.images!.length
                                    ? business!.images![index]
                                    : selectedImages[index - business!.images!.length];
                                return Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        child:
                                      Image.network(imageUrl, fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      top: -10.0,
                                      right: -8.0,
                                      child: IconButton(
                                        icon: Icon(Icons.close, color: Colors.red),
                                        onPressed: () async {
                                          if (index < business!.images!.length) {
                                            // Eliminar la imagen de la lista
                                            String imageUrl = business!.images!.removeAt(index);
                                            // Actualizar la base de datos
                                            await updateBusinessData(business!);
                                            // Eliminar la imagen del almacenamiento en la nube
                                            await _imageHandler.deleteImage(imageUrl);
                                          } else {
                                            // Eliminar la imagen de la lista de imágenes seleccionadas
                                            selectedImages.removeAt(index - business!.images!.length);
                                          }
                                          // Actualizar el estado para refrescar el GridView
                                          setState(() {});
                                          customToast.showSuccessToast('Imagen eliminada correctamente!');
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            )
                                : Container(),
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
                              // onPressed: () async { //Le he añadido async
                              //   if (_formKey.currentState!.validate()) {
                              //     _formKey.currentState!.save();
                              //     try {
                              //       List<File> images = await _imageHandler.selectMultipleImages();
                              //       List<String> imageUrls = [];
                              //       for (var image in images) {
                              //         String imageUrl = await _imageHandler.uploadImage(image);
                              //         imageUrls.add(imageUrl);
                              //       }
                              //       business?.images = imageUrls;
                              //       await updateBusinessData(business!);
                              //       customToast.showSuccessToast('Cambios guardados correctamente!');
                              //     } catch (e) {
                              //       // Manejar errores
                              //     }
                              //   }
                              // },
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (business?.images != null) {
                                    business?.images?.addAll(selectedImages);
                                  } else {
                                    business?.images = selectedImages;
                                  }
                                  await updateBusinessData(business!);
                                  selectedImages.clear();
                                  customToast.showSuccessToast('Cambios guardados correctamente!');
                                  setState(() {}); // Forzar la reconstrucción del widget
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

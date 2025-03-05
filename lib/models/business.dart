import 'package:cloud_firestore/cloud_firestore.dart';

/*
  Clase `Business` que representa una empresa en la aplicación.
  Cada instancia de `Business` contiene información detallada sobre un negocio, incluyendo su id, nombre, CIF, email, servicio, teléfono, URL, ubicación, descripción y sitio web.
  Esta clase también proporciona métodos para convertir un `DocumentSnapshot` en un objeto `Business` y viceversa. Esto es útil cuando se trabaja con Firestore, ya que permite una fácil conversión entre los documentos de Firestore y los objetos de la aplicación.
*/

class Business {
  final String id;
  String name;
  String cif;
  String email;
  String service;
  String? phone;
  // String? url;
  List<String>? images;
  String? location;
  String? aboutUs;
  String? web;

  Business({
    required this.id,
    required this.name,
    required this.cif,
    required this.email,
    required this.service,
    this.phone,
    // this.url,
    this.images,
    this.location,
    this.aboutUs,
    this.web,
  });

  // Método para convertir un DocumentSnapshot en un objeto Business
  static Business fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Business(
      id: doc.id,
      name: data['name'],
      cif: data['cif'],
      phone: data['phone'],
      email: data['email'],
      service: data['service'],
      // url: data['url'],
      images: data.containsKey('images') && data['images'].isNotEmpty
          ? List<String>.from(data['images'].map((item) => item.toString()))
          : ['https://via.placeholder.com/150'], // URL de la imagen de respaldo
      location: data['location'],
      aboutUs: data['aboutUs'],
      web: data['web'],
    );
  }

  // Método para convertir un objeto Business en un Map<String, dynamic>
  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'cif': cif,
      'phone': phone,
      'email': email,
      'service': service,
      // 'url': url,
      'images': images,
      'location': location,
      'aboutUs': aboutUs,
      'web': web,
    };
  }
}
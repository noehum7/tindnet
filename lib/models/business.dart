// class Business {
//   final String photoUrl;
//   final String companyName;
//   final String location;
//   final String aboutUs;
//   final String contactPhone;
//   final String contactEmail;
//   final String website;
//
//   Business({
//     required this.photoUrl,
//     required this.companyName,
//     required this.location,
//     required this.aboutUs,
//     required this.contactPhone,
//     required this.contactEmail,
//     required this.website,
//   });
//
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Business {
  final String id;
  String name;
  String cif;
  String email;
  String service;
  String? phone;
  String? url;
  String? location;
  String? aboutUs;
  String? web;


  // // Constructor por defecto
  // Business({
  //   this.id = '',
  //   this.name = '',
  //   this.cif = '',
  //   this.email = '',
  //   this.service = '',
  //   this.phone = '',
  //   this.url = '',
  //   this.location = '',
  //   this.aboutUs = '',
  //   this.web = '',
  // });

  // Business.fromData({
  Business({
    required this.id,
    required this.name,
    required this.cif,
    required this.email,
    required this.service,
    this.phone,
    this.url,
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
      url: data['url'],
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
      'url': url,
      'location': location,
      'aboutUs': aboutUs,
      'web': web,
    };
  }
}
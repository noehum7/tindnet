class Business {
  final String photoUrl;
  final String companyName;
  final String location;
  final String aboutUs;
  final String contactPhone;
  final String contactEmail;
  final String website;

  Business({
    required this.photoUrl,
    required this.companyName,
    required this.location,
    required this.aboutUs,
    required this.contactPhone,
    required this.contactEmail,
    required this.website,
  });
  //
  // List<Business> sampleBusinesses = [
  //   Business(
  //     photoUrl: 'url_to_photo_1',
  //     companyName: 'Company 1',
  //     location: 'Location 1',
  //     aboutUs: 'About us 1',
  //     contactPhone: 'Phone 1',
  //     contactEmail: 'Email 1',
  //     website: 'Website 1',
  //   ),
  //   // Add more businesses here
  // ];
}
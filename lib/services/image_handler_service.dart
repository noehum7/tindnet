import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ImageHandler {
  final ImagePicker _picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<File> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      throw 'No hay imágenes seleccionadas.';
    }
  }

  Future<String> uploadImage(File image) async {
    String filePath = 'images/${DateTime.now()}.png';
    await storage.ref(filePath).putFile(image);

    // Obtener la URL de descarga
    String downloadURL = await storage.ref(filePath).getDownloadURL();
    return downloadURL;
  }

  Future<String> takePhotoMessage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      String downloadUrl = await uploadImage(File(pickedFile.path));
      return 'IMAGE:' + downloadUrl; // Añade el prefijo 'IMAGE:' a la URL de la imagen
    }

    throw Exception('No se seleccionó ninguna imagen');
  }

  Future<List<File>> selectMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null) {
      return pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    } else {
      throw 'No se seleccionaron imágenes.';
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Manejar errores
      print('Error al eliminar la imagen: $e');
    }
  }

}
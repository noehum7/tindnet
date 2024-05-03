import 'package:get/get.dart';

class FormValidator {
  String? isValidName(String? text) {
    if (text == null || text.isEmpty || text.length < 3) {
      return "El nombre no es válido.";
    }
    return null;
  }

  String? isValidEmail(String? text) {
    return (text ?? "").isEmail ? null : "Este email no es válido.";
  }

  String? isValidPass(String? text) {
    if (text == null || text.length < 6) {
      return "La contraseña debe contener 6 caracteres mínimo.";
    }
    return null;
  }

  String? isValidPhone(String? text) {
    if (text == null || text.length < 9) {
      return "El número de teléfono debe contener 9 dígitos.";
    }
    return null;
  }

  String? isValidCif(String? text) {
    if (text == null || text.length < 9) {
      return "El CIF debe contener 9 caracteres.";
    }
    return null;
  }

  String? isValidService(String? text) {
    if (text == null || text.isEmpty) {
      return "Debes seleccionar un servicio.";
    }
    return null;
  }

  String? isValidUrl(String? text) {
    if (text == null || text.isEmpty) {
      return "La URL de la imagen de perfil no puede estar vacía.";
    }
    // Puedes añadir más lógica aquí para comprobar si la URL es válida
    return null;
  }

  String? isValidLocation(String? text) {
    if (text == null || text.isEmpty) {
      return "La dirección de la empresa no puede estar vacía.";
    }
    return null;
  }

  String? isValidAboutUs(String? text) {
    if (text == null || text.isEmpty) {
      return "El campo Sobre nosotros no puede estar vacío.";
    }
    if (text.split(' ').length > 30) {
      return 'Por favor, introduce un máximo de 30 palabras.';
    }
    return null;
  }

  String? isValidWeb(String? text) {
    if (text == null || text.isEmpty) {
      return "La página web de la empresa no puede estar vacía.";
    }
    // Expresión regular para validar la URL
    RegExp regex = RegExp(
        r'^(https?:\/\/)?(([\da-z\.-]+)\.([a-z\.]{2,6})|(([0-9]{1,3}\.){3}[0-9]{1,3}))([\/\w \.-]*)*\/?$');
    if (!regex.hasMatch(text)) {
      return "Por favor, introduce una URL válida.";
    }
    return null;
  }

// static String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email is required';
//     }
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   }
//
//   static String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     }
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }
//
//   static String? validateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Name is required';
//     }
//     return null;
//   }
}

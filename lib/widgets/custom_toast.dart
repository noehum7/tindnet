import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:tindnet/constants/app_colors.dart';

/*
  Clase `CustomToast` que proporciona métodos para mostrar diferentes tipos de toasts.
  Proporciona funcionalidades para:
     - Mostrar un toast de éxito: Muestra un toast con un mensaje de éxito y un icono de verificación.
     - Mostrar un toast de error: Muestra un toast con un mensaje de error y un icono de error.
     - Mostrar un toast de información: Muestra un toast con un mensaje de información.
 */

class CustomToast {
  void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: "\u2714 $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: "\u274C $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  void showInfoToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: AppColors.primaryColor,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sistema_importar_csv/main.dart';

showPostgresqlErrorDialog(String mensaje) {
  return showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => AlertDialog(
            content: Text('Hubo un error al conectarse al servidor: $mensaje'),
          ));
}

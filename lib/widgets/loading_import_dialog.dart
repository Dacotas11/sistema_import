import 'package:flutter/material.dart';
import 'package:sistema_importar_csv/utils/utilidades_postgresql.dart';

showDialogLoading(context, String path, int tipoId) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        AlertDialog(content: showDialogLoadingContent(path, tipoId)),
  );
}

showDialogLoadingContent(String path, int tipoId) {
  return Container(
    width: 200,
    height: 200,
    child: FutureBuilder(
      future: insertarArchivo(path, tipoId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${snapshot.data}'),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Text('OK')),
              )
            ],
          );
        }
      },
    ),
  );
}

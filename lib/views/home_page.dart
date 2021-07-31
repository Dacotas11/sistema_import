import 'package:flutter/material.dart';
import 'package:sistema_importar_csv/utils/select_file.dart';
import 'package:sistema_importar_csv/utils/utilidades_postgresql.dart';
import 'package:sistema_importar_csv/widgets/tipos_listView_search.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _crearAppBarHomePage(context),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      showMenuDialog(context);
                    },
                    child:
                        FittedBox(child: Text('IMPORTAR'), fit: BoxFit.contain))
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _crearAppBarHomePage(BuildContext context) {
    return AppBar(
      title: Text('Sistema de importes'),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, 'configurations'),
            child: Icon(Icons.more_vert))
      ],
    );
  }

  Future<dynamic> dialogFinal(BuildContext context, mensaje) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text(mensaje),
            ));
  }
}

showMenuDialog(context) {
  return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          // content: selectTipo(context),
          content: TiposListViewSearch(),
        );
      });
}

showLoadingDialog(context, int tipoId) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(content: loadingFile(tipoId)),
  );
}

selectTipo(context) {
  return Container(
    height: 300,
    child: FutureBuilder(
      future: getImportTipos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          List data = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 200,
                height: 200,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text('${data[index][1]}'),
                        onTap: () {
                          Navigator.pop(context);
                          showLoadingDialog(context, data[index][0]);
                        }
                        // title: Text('A'),
                        );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCELAR'))
            ],
          );
        }
      },
    ),
  );
}

loadingFile(int tipoId) {
  return Container(
    width: 200,
    height: 200,
    child: FutureBuilder(
      future: selectXSLX(tipoId),
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

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sistema_importar_csv/models/tipo_import_model.dart';
import 'package:sistema_importar_csv/utils/select_file.dart';
import 'package:sistema_importar_csv/utils/utilidades_postgresql.dart';

class PruebaPage extends StatelessWidget {
  const PruebaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dropDownKey = GlobalKey<DropdownSearchState<TipoImport>>();
    final _archivoField = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownSearch<TipoImport>(
                key: _dropDownKey,
                hint: 'Tipo de importe',
                mode: Mode.BOTTOM_SHEET,
                showSearchBox: true,
                isFilteredOnline: true,
                onFind: (String filter) => _buscarTiposImport(filter),
                dropdownBuilder: _dropTiposBuilder,
                popupItemBuilder: _popUpTiposBuilder,
                searchBoxDecoration: InputDecoration(
                    hintText: 'Buscar',
                    suffix: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.search),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _archivoField,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.more_horiz)),
                onTap: () async {
                  final file = await selectXSLXFile();
                  if (file != null) {
                    _archivoField.text = file.path;
                  }
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  showDialogLoading(context, _archivoField.text,
                      _dropDownKey.currentState!.getSelectedItem!.tipoId);
                },
                child: Text('INSERTAR'))
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     height: 25,
            //     child: Row(
            //       children: [
            //         TextField(
            //           readOnly: true,
            //         ),
            //         ElevatedButton(
            //             onPressed: null, child: Icon(Icons.more_horiz))
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _dropTiposBuilder(
      BuildContext context, TipoImport? selectedItem, String itemAsString) {
    if (selectedItem == null) {
      return Container();
    }

    return Container(
      child: Text(selectedItem.descripcion),
    );
  }

  Widget _popUpTiposBuilder(
      BuildContext context, TipoImport item, bool isSelected) {
    return Container(
      child: ListTile(
        title: Text(item.descripcion),
      ),
    );
  }
}

Future<List<TipoImport>> _buscarTiposImport(String filter) async {
  final tipos = await getImportTipos();
  List<TipoImport> resultadoFinal = [];
  for (var tipo in tipos) {
    if (tipo.descripcion.toLowerCase().contains(filter.toLowerCase())) {
      resultadoFinal.add(tipo);
    }
  }
  return resultadoFinal;
}

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

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sistema_importar_csv/models/tipo_import_model.dart';
import 'package:sistema_importar_csv/utils/buscar_tipos_import.dart';
import 'package:sistema_importar_csv/utils/select_file.dart';

import 'loading_import_dialog.dart';

Widget homePageBody(BuildContext context) {
  final _dropDownKey = GlobalKey<DropdownSearchState<TipoImport>>();
  final _archivoFieldController = TextEditingController();
  return Center(
    child: Container(
      constraints: BoxConstraints(maxWidth: 800, minWidth: 300),
      margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 50, bottom: 20),
      child: Column(
        children: [
          DropdownSearch<TipoImport>(
            key: _dropDownKey,
            hint: 'Tipo de importe',
            mode: Mode.BOTTOM_SHEET,
            showSearchBox: true,
            isFilteredOnline: true,
            onFind: (String filter) => buscarTiposImport(filter),
            dropdownBuilder: _dropTiposBuilder,
            popupItemBuilder: _popUpTiposBuilder,
            searchBoxDecoration: InputDecoration(
                hintText: 'Buscar',
                suffix: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.search),
                )),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _archivoFieldController,
            readOnly: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.more_horiz)),
            onTap: () async {
              final file = await selectXSLXFile();
              if (file != null) {
                _archivoFieldController.text = file.path;
              }
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                showDialogLoading(context, _archivoFieldController.text,
                    _dropDownKey.currentState!.getSelectedItem!.tipoId);
              },
              child: Text('IMPORTAR'))
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

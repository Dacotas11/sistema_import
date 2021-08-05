import 'package:flutter/material.dart';
import 'package:sistema_importar_csv/models/tipo_import_model.dart';
import 'package:sistema_importar_csv/utils/utilidades_postgresql.dart';
import 'package:sistema_importar_csv/views/home_page.dart';

class TiposListViewSearch extends StatefulWidget {
  @override
  _TiposListViewSearchState createState() => _TiposListViewSearchState();
}

class _TiposListViewSearchState extends State<TiposListViewSearch> {
  List<TipoImport> _allTipos = [];
  List<TipoImport> _foundTipos = [];
  @override
  initState() {
    getTipos();
    _foundTipos = _allTipos;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<TipoImport> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allTipos;
    } else {
      results = _allTipos
          .where((tipo) => tipo.descripcion
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundTipos = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Column(
        children: [
          Text('Tipos de importe', style: TextStyle(fontSize: 24)),
          SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
                labelText: 'Buscar', suffixIcon: Icon(Icons.search)),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: _foundTipos.length > 0
                ? ListView.builder(
                    itemCount: _foundTipos.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        ListTile(
                            title: Text(_foundTipos[index].descripcion),
                            onTap: () {
                              Navigator.pop(context);
                              showLoadingDialog(
                                  context, _foundTipos[index].tipoId);
                            }),
                        Divider(
                          height: 0,
                        )
                      ],
                    ),
                  )
                : Text(
                    'No se encontraron resultados',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
    );
  }

  void getTipos() async {
    final tipos = await getImportTipos();
    setState(() {
      _foundTipos = tipos;
      _allTipos = tipos;
    });
  }
}

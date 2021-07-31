import 'package:flutter/material.dart';
import 'package:sistema_importar_csv/utils/utilidades_postgresql.dart';
import 'package:sistema_importar_csv/views/home_page.dart';

class TiposListViewSearch extends StatefulWidget {
  @override
  _TiposListViewSearchState createState() => _TiposListViewSearchState();
}

class _TiposListViewSearchState extends State<TiposListViewSearch> {
  List _allUsers = [];
  List _foundUsers = [];
  @override
  initState() {
    getTipos();
    _foundUsers = _allUsers;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user[1].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundUsers = results;
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
            child: _foundUsers.length > 0
                ? ListView.builder(
                    itemCount: _foundUsers.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        ListTile(
                            title: Text(_foundUsers[index][1]),
                            onTap: () {
                              Navigator.pop(context);
                              showLoadingDialog(context, _foundUsers[index][0]);
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
      _foundUsers = tipos;
      _allUsers = tipos;
    });
  }
}

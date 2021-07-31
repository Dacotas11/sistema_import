import 'package:flutter/material.dart';
import 'package:sistema_importar_csv/utils/server_secure_storage.dart';

class ConfigurationsPage extends StatefulWidget {
  @override
  _ConfigurationsPageState createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  final _ipServerController = TextEditingController();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    _ipServerController.text = await ServerSecureStorage.getServerIp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _configurationsPageBody(),
    );
  }

  Container _configurationsPageBody() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [_crearServerIpFormulario(), _crearBotonGuardar()],
        ),
      );

  Widget _crearServerIpFormulario() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 30, right: 30),
      child: Column(
        children: [
          Text('IP del servidor'),
          TextField(
            controller: _ipServerController,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearBotonGuardar() {
    return ElevatedButton(
      onPressed: () async {
        await ServerSecureStorage.setServerIp(_ipServerController.text);
        Navigator.pop(context);
      },
      child: Text('GUARDAR'),
    );
  }
}

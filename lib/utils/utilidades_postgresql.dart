import 'dart:io';

import 'package:csv/csv.dart';
import 'package:postgres/postgres.dart';
import 'package:sistema_importar_csv/models/tipo_import_model.dart';

import 'package:sistema_importar_csv/widgets/postgresql_error_dialog.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

Future<PostgreSQLResult> sqlUtils(String sqlcmd) async {
  try {
    // final _serverIp = await ServerSecureStorage.getServerIp();
    final conexion = PostgreSQLConnection(
        '192.168.0.9', 5432, 'bits_erp_edutec',
        username: 'postgres', password: '123');
    await conexion.open();
    final resultado = await conexion.query(sqlcmd);
    await conexion.close();
    return resultado;
  } catch (e) {
    throw showPostgresqlErrorDialog('$e');
  }
}

insertLista(int tipoId, List columnas, List valores, bool isLast) async {
  await sqlUtils(
      "INSERT INTO dbo.import(tipo_id, ${columnas.join(',')}) VALUES($tipoId,'${valores.join("','")}');");
  final id = await sqlUtils(
      'SELECT rowid FROM dbo.import ORDER BY rowid DESC LIMIT 1');
  await sqlUtils(
      'SELECT dbo.after_row_import(${id.first.first}, $isLast, $tipoId);');
}

deleteTipo(int tipoId) async {
  await sqlUtils('DELETE FROM dbo.import WHERE tipo_id = $tipoId;');
}

insertImport(List list, int tipoId) async {
  await getImportTipos();
  await deleteTipo(tipoId);

  for (var i = 0; i < list.length; i++) {
    List columnas = [];
    for (var x = 0; x < list[i].length; x++) {
      columnas.add('col$x');
    }
    await insertLista(tipoId, columnas, list[i], (i == list.length - 1));
  }
}

Future<List<TipoImport>> getImportTipos() async {
  List<TipoImport> resultadoFinal = [];
  final resultado = await sqlUtils('SELECT * FROM dbo.tipo_import;');
  for (var item in resultado) {
    resultadoFinal.add(TipoImport(item[0], item[1]));
  }
  return resultadoFinal;
}

insertarArchivo(String path, int tipoId) async {
  final result = File(path);
  try {
    if (result.path.contains('.xlsx')) {
      var bytes = result.readAsBytesSync();
      var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
      var rows = [];
      for (var table in decoder.tables.keys) {
        for (var row in decoder.tables[table]!.rows) {
          rows.add(row);
        }
      }
      await insertImport(rows, tipoId);
    } else {
      final csvRaw = result.readAsStringSync();
      await insertImport(CsvToListConverter().convert(csvRaw), tipoId);
    }

    return 'Proceso realizado';
  } catch (e) {
    return 'Hubo un error, el error es: $e';
  }
}

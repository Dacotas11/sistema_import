import 'package:postgres/postgres.dart';
import 'package:sistema_importar_csv/utils/server_secure_storage.dart';

Future<PostgreSQLResult> sqlUtils(String sqlcmd) async {
  final _serverIp = await ServerSecureStorage.getServerIp();
  final conexion = PostgreSQLConnection(_serverIp, 5432, 'bits_erp_edutec',
      username: 'postgres', password: '123');
  await conexion.open();
  final resultado = await conexion.query(sqlcmd);
  await conexion.close();
  return resultado;
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

getImportTipos() async {
  List resultadoFinal = [];
  final resultado = await sqlUtils('SELECT * FROM dbo.tipo_import;');
  for (var item in resultado) {
    resultadoFinal.add(item);
  }
  return resultadoFinal;
}

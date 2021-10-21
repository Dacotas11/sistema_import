import 'package:sistema_importar_csv/models/tipo_import_model.dart';
import 'package:sistema_importar_csv/utils/utilidades_postgresql.dart';

Future<List<TipoImport>> buscarTiposImport(String filter) async {
  final tipos = await getImportTipos();
  List<TipoImport> resultadoFinal = [];
  for (var tipo in tipos) {
    if (tipo.descripcion.toLowerCase().contains(filter.toLowerCase())) {
      resultadoFinal.add(tipo);
    }
  }
  return resultadoFinal;
}

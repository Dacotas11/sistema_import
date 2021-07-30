import 'package:csv/csv.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:sistema_importar_csv/utils/utilidades_postgresql.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

selectXSLX(int tipoId) async {
  final file = OpenFilePicker()
    ..filterSpecification = {
      "Archivo EXCEL(.xlsx)": "*.xlsx",
      "Archivo CSV (.csv)": "*.csv",
    }
    ..title = 'Elegir un archivo CSV';

  final result = file.getFile();
  if (result != null) {
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
  return 'No se puede leer archivo';
}

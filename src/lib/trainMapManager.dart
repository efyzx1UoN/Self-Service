import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' as ex;

class TrainMapManager {
  Map<String, String> _stationInfo = new Map();

  static final TrainMapManager _instance = TrainMapManager._TrainMapManager();

  static TrainMapManager get instance => _instance;

  Map<String, String> get stationInfo => _stationInfo;

  TrainMapManager._TrainMapManager() {
    this.generateMap();
  }


  void generateMap() async {
    ///Open Excel Spreadsheet
    final directory = await getApplicationDocumentsDirectory();
    ByteData data = await rootBundle.load("assets/trainmap.xlsx");
    List<int> contents = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    ///Read field data from Excel Spreadsheet, adding rows to the map
    var excel = ex.Excel.decodeBytes(contents);
    int i = 0;
    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table].maxCols);
      print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        stationInfo.addAll({row[0].toString().toLowerCase():row[1]});
        //print("Map: "+row[1]+" : "+row[0].toString().toLowerCase());
        i++;
      }
    }
    //print("RECORD COUNT: "+i.toString());
  }

}
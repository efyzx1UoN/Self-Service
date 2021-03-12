import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/observerState.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' as ex;

/// Class: TrainMapManager
///
/// Description: Singleton class that controls access to database of codes
/// and station names.
class TrainMapManager {
  Map<String, String> _stationInfo = new Map();
  List<DropdownMenuItem> _stationNamesList = new List();


  static final TrainMapManager _instance = TrainMapManager._TrainMapManager();

  static TrainMapManager get instance => _instance;

  Map<String, String> get stationInfo => _stationInfo;

  List<DropdownMenuItem> get stationNames => _stationNamesList;

  ObserverState _listener;

  ObserverState get listener => _listener;

  set listener(ObserverState value) {
    _listener = value;
  }

  /// Function: TrainMapManager (Constructor)
  ///
  /// Description: Privately creates one instance and calls itself to generate
  /// the map of codes to names from file.
  TrainMapManager._TrainMapManager() {
    this.generateMap();
    this.generateList();
  }

  /// Function: generateMap
  ///
  /// Description: Opens Excel spreadsheet of codes to station names and produces
  /// private map of them.
  void generateMap() async {
    //Open Excel Spreadsheet
    final directory = await getApplicationDocumentsDirectory();
    ByteData data = await rootBundle.load("assets/trainmap.xlsx");
    List<int> contents = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    //Read field data from Excel Spreadsheet, adding rows to the map
    var excel = ex.Excel.decodeBytes(contents);
    int i = 0;
    for (var table in excel.tables.keys) {
      // print(table); //sheet Name
      // print(excel.tables[table].maxCols);
      // print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        stationInfo.addAll({row[0].toString().toLowerCase():row[1]});
        // print("Map: "+row[1]+" : "+row[0].toString().toLowerCase());
      }
    }

  }

  void generateList() async {
    final directory = await getApplicationDocumentsDirectory();
    ByteData data = await rootBundle.load("assets/trainmap.xlsx");
    List<int> contents = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    //Read field data from Excel Spreadsheet, adding rows to the map
    var excel = ex.Excel.decodeBytes(contents);
    int i = 0;
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        // stationNames.addAll({row[0].toString().toLowerCase()});
        stationNames.add(DropdownMenuItem(child: Text(row[0].toString().toLowerCase()), value: row[0].toString().toLowerCase(),));
        // print("list: " + table + " : " + row[0].toString().toLowerCase());
      }
    }
    listener.update();

  }

}
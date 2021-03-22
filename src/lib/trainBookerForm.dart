import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxi/taxiPlanner.dart';
import 'package:flutter_app/train.dart' as t1;
import 'package:flutter_app/train2.dart' as t2;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'main.dart';
import 'package:flutter_app/SharedStringData.dart';
import 'package:flutter_app/trainMapManager.dart';
import 'package:url_launcher/url_launcher.dart';



/// Class: TrainBookerPage
///
/// Description: Train Booker Page.
class TrainBookerForm extends StatefulWidget {
  @override
  TrainBookerFormState createState() {
    return TrainBookerFormState();
  }
}

/// Class: TrainBookerFormState
///
/// Description: State containing all currently active widgets on the form and
/// prepares time data for its own display.
class TrainBookerFormState extends State<TrainBookerForm> {
  final M_FORMKEY = GlobalKey<FormState>();
  Data m_data = new Data();
  String m_currentLocation = "";
  List<DropdownMenuItem> m_stationList = TrainMapManager.instance.stationNames;
  String selectedValue;
  bool _hidden = false;
  String _m_origin;
  String _m_firststation;
  String _m_destination;
  List<bool> _selections = List.generate(2, (_) => false);
  TimeOfDay _m_selectedTime = TimeOfDay.now();
  String _m_selectedTimeString = TimeOfDay.now().hour.toString()
      +":"+TimeOfDay.now().minute.toString().padLeft(2,'0');
  DateTime _m_selectedDate = DateTime.now();
  String _m_selectedDateString = DateTime.now().day.toString().padLeft(2,'0')
      +"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString();
  String _m_selectedTimeStringReturn = TimeOfDay.now().hour.toString()
      +":"+TimeOfDay.now().minute.toString().padLeft(2,'0');
  DateTime _m_selectedDateReturn = DateTime.now();
  String _m_selectedDateStringReturn = DateTime.now().day.toString().padLeft(2,'0')
      +"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString();


  @override
  void initState(){
    super.initState();
  }

  /// Function: getJsonResponse
  /// Exception: HTTP error code throws exception.
  /// Description: Convert data into API's paramter format and query the API,
  /// before returning the JSON response. If there is a HTTP error, throw an
  /// exception.
  Future<t1.Results> getJsonResponse() async {
    print("TEST");
    print(m_data.m_originLocation.toString());
    Map<String, String> stationMap = TrainMapManager.instance.stationInfo;
    print(stationMap.length);
    String origin  = stationMap[m_data.m_originLocation.toLowerCase()];
    String destination = stationMap[m_data.m_destination.toLowerCase()];
    print(origin.toString());
    print(destination.toString());
    String firststation = stationMap[m_data.m_originLocation.toLowerCase()];
    _m_origin = m_data.m_originLocation.toLowerCase();
    _m_firststation=m_data.m_originLocation.toLowerCase();
    _m_destination=m_data.m_destination.toLowerCase();
    ///TODO same for destination
    String time = _m_selectedTime.hour.toString().padLeft(2,'0')+":"+
        _m_selectedTime.minute.toString().padLeft(2,'0');
    String date = _m_selectedDate.year.toString()+"-"+
        _m_selectedDate.month.toString().padLeft(2,'0')+"-"+
        _m_selectedDate.day.toString().padLeft(2,'0');
    print("origin code: $origin, destination code: $destination");
    http.Response response = await get("https://transportapi.com/v3/uk/train/station/$origin/$date/$time/timetable.json?app_id=b1b5d114&app_key=85fa7b99e23aa90b5071c8a6f4a72026&calling_at=$destination&station_detail=calling_at&train_status=passenger");
    if(response.statusCode == 200){
      print(response.body.length);
      Map jsonResponse = jsonDecode(response.body);
      // Results result = jsonResponse.map((e) => Results.fromJson(e));
      t1.Results result = t1.Results.fromJson(jsonResponse);

      return result;
    }
    else{
      print("Code: "+response.statusCode.toString());
      throw Exception("Something went wrong, ${response.statusCode}");
    }
  }

  /// Function: getLocation
  ///
  /// Description: Receive Co-ordinates from Geolocator and update global state.
  // void getLocation() async {
  //   double lat;
  //   double long;
  //
  //   Position coords = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     lat = coords.latitude;
  //     long = coords.longitude;
  //   });
  //   final coordinates = new Coordinates(lat, long);
  //   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //
  //   setState(() {
  //     m_currentLocation = addresses.first.addressLine;
  //   });
  //
  // }

  /// Function: showReturn
  ///
  /// Description: Displays return journey options.
  void showReturn() {
    setState(() {
      _hidden = !_hidden;
    });
  }

  /// Function: hiddenReturn
  ///
  /// Description: Hides return journey options.
  void hiddenReturn() {
    setState(() {
      _hidden = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: new Form(
        key: M_FORMKEY,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SearchableDropdown.single(
              items: m_stationList,
              value: selectedValue,
              hint: "Where from?",
              searchHint: "Where from?",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
              onChanged: (value) {
                setState(() {
                  m_data.m_originLocation = value.toString();
                  print(value.toString());
                });
              },
              isExpanded: true,
            ),
            SearchableDropdown.single(
              items: m_stationList,
              hint: "Where to?",
              searchHint: "Where to?",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black),
              onChanged: (value) {
                setState(() {
                  m_data.setDestination(value);
                });
              },
              isExpanded: true,
            ),
            /*TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid address';
                }
                m_data.setStartingLocation(value);
                return null;
              },
              decoration: InputDecoration(
                hintText: m_currentLocation,
                labelText: 'From:',
                border: UnderlineInputBorder(
                ),
                fillColor: Colors.white60,
                filled: false,
              ),
            ),*/
            // SearchableDropdown(items: m_stationList, onChanged: null)
            /*TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid address';
                }
                m_data.setDestination(value);
                return null;
              },
              decoration: InputDecoration(
                labelText: 'To:',
                hintText: 'Destination',
                border: UnderlineInputBorder(),
                alignLabelWithHint: true,
                fillColor: Colors.white60,
                filled: false,
              ),
            ),*/
            Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          ).then((date) {setState(() {
                            if (date!=null) {
                              _m_selectedDateString =
                                  date.day.toString()
                                      .padLeft(2, '0')
                                      + "/" +
                                      date.month.toString()
                                          .padLeft(2, '0') +
                                      "/" +
                                      date.year.toString();
                              _m_selectedDate = date;
                            }
                          });
                          });
                        },

                        child: Text("Depart at: " + _m_selectedDateString)
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((time) {setState(() {
                            if (time != null) {
                              _m_selectedTimeString =
                                  time.hour.toString().padLeft(2, '0')
                                      + ":" +
                                      time.minute.toString().padLeft(
                                          2, '0');
                              _m_selectedTime = time;
                            }
                          });
                          });
                        },
                        child: Text("Depart at: "+_m_selectedTimeString)
                    ),
                  ),
                ]
            ),
            Visibility(
              maintainInteractivity: false,
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              visible: _hidden == true,
              child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            ).then((date) {setState(() {
                              if (date!=null) {
                                _m_selectedDateStringReturn =
                                    date.day.toString().padLeft(2, '0')
                                        + "/" +
                                        date.month.toString().padLeft(2, '0') +
                                        "/" + date.year.toString();
                                _m_selectedDateReturn = date;
                              }
                            });
                            });
                          },

                          child: Text("Return by: " + _m_selectedDateStringReturn)
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((time) {setState(() {
                              if (time!=null) {
                                _m_selectedTimeStringReturn =
                                    time.hour.toString().padLeft(2, '0')
                                        + ":" +
                                        time.minute.toString().padLeft(2, '0');
                                _m_selectedTimeStringReturn = time as String;
                              }
                            });
                            });
                          },
                          child: Text("Depart at: "+_m_selectedTimeStringReturn)
                      ),
                    ),
                  ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: hiddenReturn,
                    color: Colors.black12,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget> [
                        Text("Single"),
                        Icon(Icons.arrow_forward_outlined),

                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                      onPressed: showReturn,
                      color: Colors.black12,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget> [
                          Text("Return"),
                          Icon(Icons.compare_arrows_outlined),
                        ],
                      )
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: SizedBox(
                // padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (M_FORMKEY.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Starting Location and Destination Saved.')));
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          TrainResults(result: getJsonResponse(), parent: this, origin: _m_origin,destination: _m_destination)));
                      ///TODO same for destination add destination: _m_destination
                    }
                  },
                  child: Text('Update Route'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Class: TrainResults
///
/// Description: Response from API portion of Train Booker Page.
class TrainResults extends StatelessWidget {
  // final Future<List<Train>> journeys;
  final Future<t1.Results> result;
  final TrainBookerFormState parent;
  final String origin;
  final String destination;

  TrainResults({this.result, this.parent, this.origin, this.destination});
  ///TODO same for destination add this.destination

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Available journeys"),
        ),
        body: Center(
            child: FutureBuilder(
                future: result,
                builder: (BuildContext context,
                    AsyncSnapshot<t1.Results> snapshot) {
                  if (snapshot.hasData) {
                    print("Im building!!\n\n\n\n\n\n\n\n\n\n\n");
                    if (snapshot.data.departures.all.length == 0) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 15),
                        child: Text(
                          "No Available Trains",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    else {
                      return Row(
                        children: <Widget>[
                          Expanded(child: ListView.separated(
                              itemCount: snapshot.data.departures.all.length,
                              separatorBuilder: (BuildContext context,
                                  int index) => Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                var journey = snapshot.data.departures
                                    .all[index];
                                String origin = snapshot.data.station_name;
                                String departureTime = journey
                                    .aimed_departure_time;
                                String arrivalTime = journey.station_detail
                                    .calling_at[0].aimed_arrival_time;
                                // return ListTile(
                                //   contentPadding: const EdgeInsets.all(10),
                                //   title:Text( '${origin} --- ${journey.destination_name}'),
                                //   subtitle: Text('${departureTime} -------------- ${arrivalTime}'),
                                //   onTap: () {
                                //     nextScreen(context);
                                //   },
                                // );
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 15),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: <Widget>[
                                        ElevatedButton(
                                            onPressed: () {
                                              nextScreen(context, journey);
                                              //TODO: to be implemented to show receipt
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0, bottom: 20),
                                              child: Row(
                                                children: [
                                                  Align(
                                                      alignment: Alignment
                                                          .topLeft,
                                                      child: Icon(Icons
                                                          .directions_train_sharp,
                                                          size: 20)
                                                  ),
                                                  Column(
                                                      children: [
                                                        Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            margin: const EdgeInsets
                                                                .only(
                                                                left: 5.0),
                                                            child: Text(
                                                              '$departureTime',
                                                              style: TextStyle(
                                                                  fontSize: 10.0),
                                                            )
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            margin: const EdgeInsets
                                                                .only(
                                                                left: 5.0),
                                                            child: Text(
                                                              '$origin',
                                                              style: TextStyle(
                                                                  fontSize: 15.0),
                                                            )
                                                        ),
                                                      ]
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                          alignment: Alignment
                                                              .center,
                                                          margin: const EdgeInsets
                                                              .only(
                                                              left: 5.0),
                                                          child: Text(
                                                            'how many hours?',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 10.0,
                                                                fontStyle: FontStyle
                                                                    .italic),
                                                          )
                                                      ),
                                                      Container(
                                                          alignment: Alignment
                                                              .center,
                                                          margin: const EdgeInsets
                                                              .only(
                                                              left: 5.0),
                                                          child: Text(
                                                            ' ----> ',
                                                            style: TextStyle(
                                                                fontSize: 15.0),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                          alignment: Alignment
                                                              .topRight,
                                                          margin: const EdgeInsets
                                                              .only(left: 5.0,
                                                              right: 5.0),
                                                          child: Text(
                                                            '$arrivalTime',
                                                            style: TextStyle(
                                                                fontSize: 10.0),
                                                          )
                                                      ),

                                                      Container(
                                                          alignment: Alignment
                                                              .topRight,
                                                          margin: const EdgeInsets
                                                              .only(left: 5.0,
                                                              right: 5.0),
                                                          child: Text(
                                                            '${journey
                                                                .destination_name}',
                                                            style: TextStyle(
                                                                fontSize: 15.0),
                                                          )
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ))
                        ],
                      );
                    }
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 82.0,
                        ));
                  }

                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20.0,
                              width: 40.0,
                            )
                          ]
                      )
                  );
                })
        )
    );
  }

  /// Function: secondQuery
  /// Exception: HTTP error code throws exception.
  /// Description: Convert data into API's paramter format and query the API,
  /// before returning the JSON response. If there is a HTTP error, throw an
  /// exception.
  Future<t2.Results> secondQuery(t1.Train journey) async {
    String service = journey.service;
    print(service);
    String time = journey.aimed_departure_time;
    String date = this.parent._m_selectedDate.year.toString()+"-"+
        this.parent._m_selectedDate.month.toString().padLeft(2,'0')+"-"+
        this.parent._m_selectedDate.day.toString().padLeft(2,'0');
    print("TEST: $service, $date, $time");
    Map<String, String> stationMap = TrainMapManager.instance.stationInfo;

    http.Response response = await get(journey.service_timetable.id);
/*    http.Response response = await get(
        "https://transportapi.com/v3/uk/train/service/$service/$date/$time/timetable.json?app_id=b1b5d114&app_key=85fa7b99e23aa90b5071c8a6f4a72026");*/
    if (response.statusCode == 200) {
      print(response.body.length);
      Map jsonResponse = jsonDecode(response.body);
      // Results result = jsonResponse.map((e) => Results.fromJson(e));
      t2.Results result = t2.Results.fromJson(jsonResponse);
      return result;
    }
    else{
      throw Exception("Something went wrong, ${response.statusCode}");
    }
  }

  /// Function: _nextScreen
  ///
  /// Description: Navigates to the next Summary Page
  void nextScreen(BuildContext context, t1.Train journey) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Train Selected.')));
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        TrainSummary(result: secondQuery(journey), parent: this.parent, origin: this.origin, destination: this.destination,)));
  }
}

///Class: Train Summary
///
/// Description: Shows summary of specified Train journey
class TrainSummary extends StatelessWidget{
  final Future<t2.Results> result;
  final TrainBookerFormState parent;
  final String origin;
  final String destination;

  TrainSummary({this.result, this.parent, this.origin,this.destination});
  ///TODO same for destination add destination: this.destination
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Train Journey Summary"),
      ),
      body: Center(
        child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                      future: result,
                      builder: (BuildContext context,
                          AsyncSnapshot<t2.Results> snapshot){
                        if (snapshot.hasData) {
                          print("Im building!!\n\n\n\n\n\n\n\n\n\n\n");
                          if (snapshot.data.stops.length == 0) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 15),
                              child: Text(
                                "No Stops Found",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          else {
                            return Column(
                              children: <Widget>[
                                Expanded(
                                  child: ListView.separated(
                                      itemCount: snapshot.data.stops.length,
                                      separatorBuilder: (BuildContext context,
                                          int index) => Divider(),
                                      itemBuilder: (BuildContext context, int index) {
                                        var journey = snapshot.data.stops[index];

                                        String station_name = journey.station_name;
                                        String aimed_arrival_time = journey.aimed_arrival_time;
                                        String aimed_departure_time = journey.aimed_departure_time;
                                        var time = aimed_arrival_time == null ? aimed_departure_time : aimed_arrival_time;
                                        if (station_name == origin){
                                          ///display it in bold
                                          station_name=origin;
                                        }else{

                                        }
                                        // return ListTile(
                                        //   contentPadding: const EdgeInsets.all(10),
                                        //   title:Text( '${origin} --- ${journey.destination_name}'),
                                        //   subtitle: Text('${departureTime} -------------- ${arrivalTime}'),
                                        //   onTap: () {
                                        //     nextScreen(context);
                                        //   },
                                        // );
                                        return ListTile(

                                          leading: station_name.toLowerCase() == origin || station_name.toLowerCase()==destination
                                          ///TODO pass destination
                                              ? const Icon(CupertinoIcons.circle, size: 15.0):
                                          const Icon(Icons.circle, size: 10.0),
                                          title: station_name.toLowerCase() == origin || station_name.toLowerCase()==destination
                                              ?  Text( " $station_name: $time", style: new TextStyle(fontWeight: FontWeight.bold,
                                              fontSize: 20.0)):
                                          Text( " $station_name: $time", style: new TextStyle( fontSize: 18.0)),
                                          /*subtitle: index == snapshot.data.stops.length -1
                                              ? Text(""):
                                          Text("↓", textAlign: TextAlign.center, style: new TextStyle(
                                              fontSize: 20.0, fontWeight: FontWeight.bold )),*/

                                          trailing: const Icon (Icons.train),

                                        );
                                      }
                                  ),
                                )
                              ],
                            );
                          }
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 82.0,
                              ));
                        }
                        return Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 20.0,
                                    width: 40.0,
                                  )
                                ]
                            )
                        );
                      }),
                ),

                RaisedButton(
                    color: Colors.pink,
                    onPressed: () => launch('https://www.thetrainline.com'),
                    child: const Text('Book on Trainline', style: TextStyle(color: Colors.white)))
              ],
            )
        ),
      ),
    );
    throw UnimplementedError();
  }
}




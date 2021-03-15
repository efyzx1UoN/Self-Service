import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxi/taxiPlanner.dart';
import 'package:flutter_app/train.dart';
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
  Future<Results> getJsonResponse() async {
    print("starting location: ${m_data.m_startingLocation}");
    Map<String, String> stationMap = TrainMapManager.instance.stationInfo;
    print(stationMap.length);
    String origin  = stationMap[m_data.m_startingLocation.toLowerCase()];
    String destination = stationMap[m_data.m_destination.toLowerCase()];
    print("origin code: $origin, destination code: $destination");
    http.Response response = await get("https://transportapi.com/v3/uk/train/station/$origin///timetable.json?app_id=b1b5d114&app_key=85fa7b99e23aa90b5071c8a6f4a72026&calling_at=$destination&station_detail=calling_at&train_status=passenger");
    if(response.statusCode == 200){
      print(response.body.length);
      Map jsonResponse = jsonDecode(response.body);
      // Results result = jsonResponse.map((e) => Results.fromJson(e));
      Results result = Results.fromJson(jsonResponse);

      return result;
    }
    else{
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
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                  m_data.setStartingLocation(value);
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
                                                _m_selectedDateString = date.day.toString().padLeft(2,'0')
                                                    +"/"+date.month.toString().padLeft(2,'0')+"/"+date.year.toString();
                                                _m_selectedDate = date;
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
                                _m_selectedTimeString = time.hour.toString().padLeft(2,'0')
                                    +":"+time.minute.toString().padLeft(2,'0');
                                _m_selectedTime = time;
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
                          _m_selectedDateStringReturn = date.day.toString().padLeft(2,'0')
                              +"/"+date.month.toString().padLeft(2,'0')+"/"+date.year.toString();
                          _m_selectedDateReturn = date;
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
                          _m_selectedTimeStringReturn = time.hour.toString().padLeft(2,'0')
                              +":"+time.minute.toString().padLeft(2,'0');
                          _m_selectedTimeStringReturn = time as String;
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
                          TrainResults(result: getJsonResponse())));
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
  final Future<Results> result;
  TrainResults({this.result});


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
              AsyncSnapshot<Results> snapshot){
              if(snapshot.hasData){
                print("Im building!!\n\n\n\n\n\n\n\n\n\n\n");
                if(snapshot.data.departures.all.length == 0){
                  return Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Text(
                      "There are no direct train services for your trip. Please try a different route.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }
                else{
                  return Row(
                    children: <Widget>[
                      Expanded(child: ListView.separated(
                        itemCount: snapshot.data.departures.all.length,
                        separatorBuilder: (BuildContext context, int index) => Divider(),
                        itemBuilder: (BuildContext context, int index){
                          var journey = snapshot.data.departures.all[index];
                          String origin = snapshot.data.station_name;
                          String departureTime = journey.aimed_departure_time;
                          String arrivalTime = journey.station_detail.calling_at[0].aimed_arrival_time;
                          // return ListTile(
                          //   contentPadding: const EdgeInsets.all(10),
                          //   title:Text( '${origin} --- ${journey.destination_name}'),
                          //   subtitle: Text('${departureTime} -------------- ${arrivalTime}'),
                          //   onTap: () {
                          //     nextScreen(context);
                          //   },
                          // );
                          return Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      nextScreen(context);
                                      //TODO: to be implemented to show receipt
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 20.0, bottom: 20 ),
                                      child: Row(
                                        children: [
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Icon(Icons.directions_train_sharp, size: 20)
                                          ),
                                          Column(
                                              children: [
                                                Container(
                                                    alignment: Alignment.topLeft,
                                                    margin: const EdgeInsets.only( left: 5.0),
                                                    child: Text(
                                                      '$departureTime',
                                                      style: TextStyle( fontSize: 10.0),
                                                    )
                                                ),
                                                Container(
                                                    alignment: Alignment.topLeft,
                                                    margin: const EdgeInsets.only( left: 5.0),
                                                    child: Text(
                                                      '$origin',
                                                      style: TextStyle( fontSize: 15.0),
                                                    )
                                                ),
                                              ]
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.only( left: 5.0),
                                                  child: Text(
                                                    'how many hours?',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle( fontSize: 10.0, fontStyle: FontStyle.italic),
                                                  )
                                              ),
                                              Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.only( left: 5.0),
                                                  child: Text(
                                                    ' ----> ',
                                                    style: TextStyle( fontSize: 15.0),
                                                  )
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                  alignment: Alignment.topRight,
                                                  margin: const EdgeInsets.only( left: 5.0, right: 5.0),
                                                  child: Text(
                                                    '$arrivalTime',
                                                    style: TextStyle( fontSize: 10.0),
                                                  )
                                              ),

                                              Container(
                                                  alignment: Alignment.topRight,
                                                  margin: const EdgeInsets.only( left: 5.0, right: 5.0),
                                                  child: Text(
                                                    '${journey.destination_name}',
                                                    style: TextStyle( fontSize: 15.0),
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
              if(snapshot.hasError){
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
  /// Function: _nextScreen
  ///
  /// Description: Navigates to the next Summary Page
  void nextScreen(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrainSummary()));
  }
}

///Class: Train Summary
///
/// Description: Shows summary of specified Train journey
class TrainSummary extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Train Journey Summary"),
      ),
      body: Center(
        child: Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
          child: Column(

          children: [
            RaisedButton(
                color: Colors.pink,
                onPressed: () => launch('https://www.thetrainline.com'),
                child: const Text('Book on Trainline', style: TextStyle(color: Colors.white)))],
        )
        ),
        ),
      ),
    );
    throw UnimplementedError();
  }
}


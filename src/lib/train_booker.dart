import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxi/taxiAlbum.dart';
import 'package:flutter_app/taxi/taxiPlanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'main.dart';

class Train_BookerPage extends StatefulWidget {
  Train_BookerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Train_BookerPageState createState() => _Train_BookerPageState();

}
class _Train_BookerPageState extends State<Train_BookerPage> {
  String startingLocation;
  String destination;
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();

  }

  void _pageHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Train Plan"),
      ),
      body: new ListView(
          children: <Widget> [
            MyCustomForm(),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment(-1.0,-1.0),
              child: Row(
                children: <Widget>[
                  FutureBuilder<Album>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.m_title);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }

}
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  Data data = new Data();
  String currentLocation = "";


  @override
  void initState(){
    super.initState();
    getLocation();
  }

  void getLocation() async {
    double lat;
    double long;

    Position coords = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = coords.latitude;
      long = coords.longitude;
    });
    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      currentLocation = addresses.first.addressLine;
    });

  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: new Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid address';
                  }
                  data.startingLocation = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: currentLocation,
                  labelText: 'From:',
                  border: UnderlineInputBorder(
                  ),
                  fillColor: Colors.white60,
                  filled: false,
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid address';
                  }
                  data.destination = value;
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
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Starting Location and Destination Saved.')));
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
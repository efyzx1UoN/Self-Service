import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxiPlanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'main.dart';

class TrainBookerForm extends StatefulWidget {
  @override
  TrainBookerFormState createState() {
    return TrainBookerFormState();
  }

}
class TrainBookerFormState extends State<TrainBookerForm> {
  final M_FORMKEY = GlobalKey<FormState>();
  Data m_data = new Data();
  String m_currentLocation = "";


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
      m_currentLocation = addresses.first.addressLine;
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
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid address';
                }
                m_data.startingLocation = value;
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
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid address';
                }
                m_data.destination = value;
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
                    if (M_FORMKEY.currentState.validate()) {
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
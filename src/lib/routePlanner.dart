// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class RoutePlannerPage extends StatefulWidget {
  RoutePlannerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RoutePlannerPageState createState() => _RoutePlannerPageState();

}

class _RoutePlannerPageState extends State<RoutePlannerPage> {
  void _pageHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Route Plan"),
      ),
      body: new ListView(
          children: <Widget> [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment(-1.0,-1.0),
              child: Row(
                children: <Widget>[
                  // TextButton(
                  //   style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                  //   onPressed: _pageHome,
                  //   child: Text('Home'),
                  // ),
                ],
              ),
            ),
            MyCustomForm(),
            Container(
              child: new Image.network('https://www.thestatesman.com/wp-content/uploads/2020/04/googl_ED.jpg',
                fit:BoxFit.fitHeight,
              ),
              height: 420,
              color: Colors.pinkAccent,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                          .showSnackBar(SnackBar(content: Text('Planning route...')));
                    }
                  },
                  child: Text('Find Route'),
                ),
              ),
              ),
            ],
          ),
        ),
      );
    }
  }
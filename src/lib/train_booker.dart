import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxiPlanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'main.dart';
import 'package:flutter_app/trainBookerForm.dart';

class Train_BookerPage extends StatefulWidget {
  Train_BookerPage({Key key, this.M_TITLE}) : super(key: key);

  final String M_TITLE;

  @override
  _Train_BookerPageState createState() => _Train_BookerPageState();

}
class _Train_BookerPageState extends State<Train_BookerPage> {
  String m_startingLocation;
  String m_destination;
  Future<Album> m_futureAlbum;

  @override
  void initState() {
    super.initState();
    m_futureAlbum = fetchAlbum();

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
            TrainBookerForm(),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment(-1.0,-1.0),
              child: Row(
                children: <Widget>[
                  FutureBuilder<Album>(
                    future: m_futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.title);
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


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxi/taxiAlbum.dart';
import 'package:flutter_app/taxi/taxiPlanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import '../main.dart';
import '../routePlanner.dart';

class TaxiPlannerPageState extends State<TaxiPlannerPage> {
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
        title: Text("New Taxi Plan"),
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
                    future: m_futureAlbum,
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
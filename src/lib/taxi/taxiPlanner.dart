import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import '../main.dart';
import 'TaxiPlannerPageState.dart';




//import 'package:com.uber.sdk.android.core.UberSdk';
//import 'package:com.uber.sdk.core.auth.Scope';
//import 'package:com.uber.sdk.rides.client.SessionConfiguration';

/// Class: TaxiPlannerPage()
///
/// Description: Taxi booker page
class TaxiPlannerPage extends StatefulWidget {
  TaxiPlannerPage({Key key, this.m_title}) : super(key: key);

  final String m_title;

  @override
  TaxiPlannerPageState createState() => TaxiPlannerPageState();

}

/// Function fetchDetails()
///
/// Description: performs HTTP request and returns JSON response data
Future<http.Response> fetchDetails() {
  return http.get("https://m.uber.com/?client_id=0");
}


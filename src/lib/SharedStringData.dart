import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxi/taxiAlbum.dart';
import 'package:flutter_app/taxi/taxiPlanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'main.dart';
import 'package:flutter_app/trainBookerForm.dart';
import 'package:flutter_app/routePlanner.dart';

/// Class: Data
///
/// Description: Storage class to contain location details to transfer from
/// other pages with a route planner.
class Data {
  String _m_destination = "nowhere";
  String _m_startingLocation = "nowhere";

  String get m_destination => _m_destination;

  set m_destination(String value) {
    _m_destination = value;
  }

  String getStartingLocation(){
    return _m_startingLocation;
  }

  setStartingLocation(String value) {
    _m_startingLocation = value;
  }

  String getDestination(){
    return _m_destination;
  }

  setDestination(String value) {
    _m_destination = value;
  }

  String get m_startingLocation => _m_startingLocation;

  set m_startingLocation(String value) {
    _m_startingLocation = value;
  }
}
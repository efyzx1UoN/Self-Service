import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import '../main.dart';
import 'TaxiPlannerPageState.dart';

class Album {
  final int m_userId;
  final int m_id;
  final String m_title;

  Album({this.m_userId, this.m_id, this.m_title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      m_userId: json['userId'],
      m_id: json['id'],
      m_title: json['title'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response = await http.get("https://m.uber.com/?client_id=");

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Failed to load album');
    return null;
  }
}

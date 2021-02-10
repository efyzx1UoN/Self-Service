import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import '../main.dart';
import '../routePlanner.dart';

class MyCustomForm extends StatefulWidget {
  @override
  RoutePlannerFormState createState() {
    return RoutePlannerFormState();
  }
}
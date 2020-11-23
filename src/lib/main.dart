import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routePlanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self Service App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Self Service: Home'),


    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _pageRoutePlanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoutePlannerPage()),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                onPressed: _pageRoutePlanner,
                child: Text('New Route Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


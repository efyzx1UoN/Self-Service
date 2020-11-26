import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

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
        title: Text('New Route Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Container(
              alignment: Alignment(-1.0,-1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Starting point (Current Location)',
                            labelText: 'Current Location',
                            border: InputBorder.none,
                            fillColor: Colors.white60,
                            filled: true,
                        ),
                      ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Visit'),
      ),
      body: Center(
          child: Container(
            alignment: Alignment(-1.0,-1.0),
            child: Row(
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                  onPressed: _pageHome,
                  child: Text('Home'),
                ),
              ],
            ),
          )
      ),
    );
  }
}
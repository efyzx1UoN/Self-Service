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
        title: Text("New Route Plan"),
      ),
      body: new ListView(
          children: <Widget> [
            Container(
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
            ),
             Container(
              child: new Image.network('https://www.thestatesman.com/wp-content/uploads/2020/04/googl_ED.jpg',
                fit:BoxFit.fitHeight,
              ),
              height: 700,
              color: Colors.pinkAccent,
              margin: const EdgeInsets.fromLTRB(30, 200, 30, 30),
            ),
          ]
      ),
    );
  }
}
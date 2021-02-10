import 'package:flutter/material.dart';
import 'routePlanner.dart';
import 'taxi/taxiPlanner.dart';
import 'train_booker.dart';
import 'package:flutter_app/SharedStringData.dart';

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
      home: _homePage(title: 'Self Service: Home'),
    );
  }
}

class _homePage extends StatefulWidget {
  _homePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<_homePage> {
  Data _m_data = new Data();

  Future _m_pageRoutePlanner() async {
    final _m_result = await Navigator.of(context).push(_createRoute(RoutePlannerPage()));
    _m_data = _m_result;
  }

  Future _m_pageTaxiPlanner() async {
    final _m_result = await Navigator.of(context).push(_createRoute(TaxiPlannerPage()));
    _m_data = _m_result;
  }
  Future _m_pagetrain_booker() async {
    final _m_result = await Navigator.of(context).push(_createRoute(Train_BookerPage()));
    _m_data = _m_result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self Service: Home"),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                onPressed: () {
                  _m_pageRoutePlanner();
                },
                child: Text('New Route Plan'),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                onPressed: () {
                  _m_pageTaxiPlanner();
                },
                child: Text('New Taxi Plan'),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                onPressed: () {
                  _m_pagetrain_booker();
                },
                child: Text('New Train Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute(StatefulWidget page) {
  return  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var _m_begin = Offset(0.0, 1.0);
      var _m_end = Offset.zero;
      var _m_curve = Curves.ease;

      var _m_tween = Tween(begin: _m_begin, end: _m_end).chain(CurveTween(curve: _m_curve));

      return SlideTransition(
        position: animation.drive(_m_tween),
        child: child,
      );
    },
  );
}


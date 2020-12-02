import 'package:flutter/material.dart';
import 'routePlanner.dart';
import 'taxiPlanner.dart';
import 'train_booker.dart';
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
  Data data = new Data();

  Future _pageRoutePlanner() async {
    final result = await Navigator.of(context).push(_createRoute(RoutePlannerPage()));
    data = result;
  }

  Future _pageTaxiPlanner() async {
    final result = await Navigator.of(context).push(_createRoute(TaxiPlannerPage()));
    data = result;
  }
  Future _pagetrain_booker() async {
    final result = await Navigator.of(context).push(_createRoute(Train_BookerPage()));
    data = result;
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
                  _pageRoutePlanner();
                },
                child: Text('New Route Plan'),
              ),

              TextButton(
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                onPressed: () {
                  _pageTaxiPlanner();
                },
                child: Text('New Taxi Plan'),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                onPressed: () {
                  _pagetrain_booker();
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
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Data {
  String destination = "nowhere";
  String startingLocation = "nowhere";
}
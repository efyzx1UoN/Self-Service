import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _pageNewVisit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewVisitPage()),
    );
  }

  void _pageBookedVisit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookedVisitPage()),
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
                onPressed: _pageNewVisit,
                child: Text('Book a New Visit'),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                onPressed: _pageBookedVisit,
                child: Text('View your Booked Visits'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class NewVisitPage extends StatefulWidget {
  NewVisitPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewVisitPageState createState() => _NewVisitPageState();
}

class _NewVisitPageState extends State<NewVisitPage> {
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


class BookedVisitPage extends StatefulWidget {
  BookedVisitPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BookedVisitPageState createState() => _BookedVisitPageState();
}

class _BookedVisitPageState extends State<BookedVisitPage> {
  void _pageHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void _pageNewVisit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewVisitPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Visits'),
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
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
                onPressed: _pageNewVisit,
                child: Text('Book a New Visit'),
              ),
            ],
          ),
        )
      ),
    );
  }
}
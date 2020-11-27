import 'package:flutter/material.dart';

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
            MyCustomForm(),
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

  class MyCustomForm extends StatefulWidget {
    @override
    MyCustomFormState createState() {
      return MyCustomFormState();
    }

  }
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
    @override
    Widget build(BuildContext context) {
      // Build a Form widget using the _formKey created above.
      return Container(
          child: new Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Starting point (Current Location)',
                  labelText: 'From:',
                  border: InputBorder.none,
                  fillColor: Colors.white60,
                  filled: true,
                ),
              ),
             TextFormField(
               validator: (value) {
                 if (value.isEmpty) {
                   return 'Please enter a valid address';
                 }
                 return null;
               },
               decoration: InputDecoration(
                 labelText: 'To',
                 border: InputBorder.none,
                 fillColor: Colors.white60,
                 filled: true,
               ),
             ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Planning route...')));
                    }
                  },
                  child: Text('Route'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Route Plan'),
      ),
      body: MyCustomForm(),
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
      return Form(
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
           Expanded(child: TextFormField(
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
      );
    }

  }
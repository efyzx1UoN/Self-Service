import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/routePlanner.dart';
import 'main.dart';



class Hotel_BookingPage extends StatefulWidget {
  Hotel_BookingPage({Key key, this.M_TITLE}) : super(key: key);

  final String M_TITLE;

  @override
  _Hotel_BookingPageState createState() => _Hotel_BookingPageState();
}
class _Hotel_BookingPageState extends State<Hotel_BookingPage> {
  var TextFieldController1=TextEditingController();
  var TextFieldController2=TextEditingController();
  var TextFieldController3=TextEditingController();



  //String m_startingLocation;
  //String m_destination;



  void _pageHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Hotel Plan"),
      ),
      body: new ListView(
      children:<Widget>[

        Container(
          //margin: EdgeInsets.all(50.0),
          width: 200.0,
          height: 40.0,
          child: TextField(controller:TextFieldController1,
                           focusNode:FocusNode(),
                           decoration:InputDecoration(
                           suffixIcon: Icon(Icons.location_searching),
                               border:OutlineInputBorder(),
                           ),

          ),
        ),
        Container(
           alignment: Alignment.center,
          child: Row(

          children: <Widget>[
            Container(

                width:210,
                height: 40.0,
                child:TextField(controller:TextFieldController2,
                       focusNode:FocusNode(),
                               decoration:InputDecoration(
                                 icon: Icon(Icons.access_time),
                            suffixIcon: Icon(Icons.arrow_forward),
                                ),
                                 ),
                ),
            Container(
              width: 200,
              height: 40.0,
              child:TextField(controller:TextFieldController3,
                focusNode:FocusNode(),
                decoration:InputDecoration(

                  icon: Icon(Icons.access_time),
                  //suffixIcon: Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ],
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.pink),
          child: Text('Search'),
        )
      ],
      ),
      );

  }
}
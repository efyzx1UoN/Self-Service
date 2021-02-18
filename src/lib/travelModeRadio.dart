import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class TravelModeRadio extends StatefulWidget{
  @override
  _TravelModeRadioState createState() {
    return _TravelModeRadioState();
  }
}

class _TravelModeRadioState extends State<TravelModeRadio>{
  List<String> lst = ['train','walk','car','bus'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context){
    return Container(
      child: Row(
        children: <Widget>[
          modeRadio(lst[0], 0),
          modeRadio(lst[1], 1),
          modeRadio(lst[2], 2),
          modeRadio(lst[3], 3),
        ],
      ),
    );
  }

  void changeIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  Widget modeRadio(String txt,int index){
    return OutlineButton(
        onPressed: () => changeIndex(index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0)),
        borderSide: BorderSide(color: selectedIndex == index ? Colors.pink : Colors.grey),
        color: Colors.pink,
        focusColor: Colors.pinkAccent,
        child: Image(
          image:AssetImage('assets/'+txt+'.png'),
          height: 16,
          width: 16,
        ),
    );
  }
}
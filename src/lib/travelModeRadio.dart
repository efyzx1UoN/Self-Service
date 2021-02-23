import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/routePlanner.dart';


class TravelModeRadio extends StatefulWidget{
  RoutePlannerFormState m_parent;
  TravelModeRadio(RoutePlannerFormState routePlannerFormState){
    m_parent = routePlannerFormState;
  }


  @override
  _TravelModeRadioState createState() {
    return _TravelModeRadioState(m_parent);
  }
}

class _TravelModeRadioState extends State<TravelModeRadio>{
  List<String> lst = ['train','walk','car','bus'];
  int selectedIndex = 0;

  _TravelModeRadioState(RoutePlannerFormState m_parent);

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
      switch(index){
        case 0:
          widget.m_parent.m_geoTracker.m_travelMode = "transit";
          widget.m_parent.m_geoTracker.m_transitMode = "train";
          break;
        case 1:
          widget.m_parent.m_geoTracker.m_travelMode = "walking";
          break;
        case 2:
          widget.m_parent.m_geoTracker.m_travelMode = "driving";
          break;
        case 3:
          widget.m_parent.m_geoTracker.m_travelMode = "transit";
          widget.m_parent.m_geoTracker.m_transitMode = "bus";
          break;
      }
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
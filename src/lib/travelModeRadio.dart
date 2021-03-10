import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/routePlanner.dart';

/// Class: TravelModeRadio
///
/// Description: Section of RoutePlannerForm that handles transit options.
class TravelModeRadio extends StatefulWidget{
  RoutePlannerFormState m_parent;
  TravelModeRadio(RoutePlannerFormState routePlannerFormState){
    m_parent = routePlannerFormState;
  }

  @override
  _TravelModeRadioState createState() {
    return _TravelModeRadioState();
  }
}

/// Class: TravelModeRadioState
///
/// Description: State containing all currently active widgets and how to
/// operate on them.
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

  /// Function: changeIndex
  ///
  /// Description: Take a new index of the radio and set the observing form's
  /// selected travel and transit mode.
  void changeIndex(int index){
    setState(() {
      selectedIndex = index;
      if(index == 0){
        widget.m_parent.m_trainVisibility = true;
      }
      else{
        widget.m_parent.m_trainVisibility = false;
      }
      widget.m_parent.m_routeVisibility = !widget.m_parent.m_trainVisibility;
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
      widget.m_parent.update();
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
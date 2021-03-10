import 'package:flutter/cupertino.dart';

/// Class: ObserverState
///
/// Description: Sub-class of State which allows external observables to
/// update the State's display.
abstract class ObserverState extends State{
  void update(){
    setState(() {});
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'routePlanner.dart';
import 'package:flutter_app/routePlanner.dart';

class routeDirections extends Container {
  final double CONTAINER_TWO_HEIGHT = 500;
  RoutePlannerFormState _m_parent;

  routeDirections(RoutePlannerFormState parent) {
    this._m_parent = parent;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _m_parent.toggleMap,
            child: Text('Find New Route'),
          ),
        ),
        Text(_m_parent.m_geoTracker.m_responseBody),
        Container(
          height: CONTAINER_TWO_HEIGHT,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        child: Row(
                          children: <Widget>[
                            Text('Route $index'),
                            ElevatedButton(
                                child: Text('Select'))
                          ],
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/geoTracker.dart';
import 'routePlanner.dart';
import 'package:flutter_app/routePlanner.dart';
import 'package:flutter_app/route.dart';

class routeDirections extends Container {
  final double CONTAINER_TWO_HEIGHT = 500;
  RoutePlannerFormState _m_parent;
  geoTracker _m_geoTracker;

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
        // Text(_m_parent.m_geoTracker.getRoutes().toString()),
        // Container(
        //   height: CONTAINER_TWO_HEIGHT,
        //   child: CustomScrollView(
        //     slivers: <Widget>[
        //       SliverList(
        //         delegate: SliverChildBuilderDelegate(
        //                 (BuildContext context, int index) {
        //               return Container(
        //                 child: Row(
        //                   children: <Widget>[
        //                     Text('Route $index'),
        //                     ElevatedButton(
        //                         child: Text('Select'))
        //                   ],
        //                 ),
        //               );
        //             }
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        Container(
          height: CONTAINER_TWO_HEIGHT,
            child: SafeArea(
              child:FutureBuilder(
                future: _m_parent.m_geoTracker.getRoutes(),
                builder: (BuildContext context,
                  AsyncSnapshot<List<MapRoute>> snapshot){
                    if(snapshot.hasData){
                      print("length of snapshot data is ${snapshot.data.length}");
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Card(
                                color: Colors.white24,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index){
                                    var route = snapshot.data;

                                    return ListTile(
                                      title: Text('1. ${snapshot.data[0].legs[0].steps[0].html_instructions}'),
                                      subtitle: Text('info: ${snapshot.data.length}'),
                                    );
                                  },
                                padding: EdgeInsets.only(top:50, bottom: 50),),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    if(snapshot.hasError){
                      return Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 82.0,
                          ));
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20.0,
                            width: 40.0,
                          )
                        ]
                      )
                    );
                },
              )
        )
        )
      ],
    );
  }
}

// class RoutesList extends StatelessWidget{
//   final List<MapRoute> mapRoutes;
//
//   RoutesList({Key key, this.mapRoutes}) : super(key : key);
//
//   @override
//   Widget build(BuildContext context){
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemCount: mapRoutes.length,
//       itemBuilder: (context, index){
//         return ListTile(
//           leading: Icon(Icons.album),
//           title: Text(mapRoutes[index].m_routes["routes"]),
//         )
//       }
//     )
//   }
// }

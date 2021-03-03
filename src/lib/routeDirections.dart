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


  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, ' ');
  }

  String directionMessage(Steps step) {
    String string = step.travel_mode+" ";
    switch (step.travel_mode){
      case "TRANSIT": {
        string += step.transit_details.headsign+"\n";
        string += "Departure from ";
        string += step.transit_details.departure_stop.name+": ";
        string += step.transit_details.departure_time.text+"\n";
        string += "Arriving at ";
        string += step.transit_details.arrival_stop.name+": ";
        string += step.transit_details.arrival_time.text+"\n";
        string += step.transit_details.headsign+"\n";
      };
      break;
      case "DRIVING": {string += step.distance.text.toString();}; break;
      case "WALKING": {string += step.distance.text.toString();}; break;
    }
    return string;
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

        Visibility(
          visible: _m_parent.m_routeVisibility,
          child: Container(
              height: CONTAINER_TWO_HEIGHT,
                  child: FutureBuilder(
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
                                  color: Colors.white,
                                  child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context, int index){
                                      var route = snapshot.data;
                                      return Container(
                                        padding: EdgeInsets.only(left: 30, right: 30),
                                        height: 50,
                                        child: Row(
                                          children: <Widget>[
                                              Text.rich(
                                                TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(text: '${route[index].legs[0].duration.text}',
                                                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                                                    ),
                                                    TextSpan(text: '\n${route[index].legs[0].distance.text}',
                                                             style: TextStyle(fontSize: 15, color: Colors.grey)
                                                    ),
                                                  ],
                                                )
                                              ),
                                            Spacer(),
                                            ElevatedButton(
                                                onPressed: () {
                                                  _m_parent.m_routeVisibility = false;
                                                  _m_parent.m_stepsVisibility = true;
                                                  _m_parent.m_selectedRouteIndex = index;
                                                  _m_parent.update();
                                                },
                                                child: Text('GO',
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                           )
                                            )
                                          ],
                                        ),
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
          ),
        ),
        Visibility(
          visible: _m_parent.m_stepsVisibility,
          child: Container(
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
                                    itemCount: snapshot.data[_m_parent.m_selectedRouteIndex].legs[0].steps.length,
                                    itemBuilder: (BuildContext context, int index){
                                      var route = snapshot.data;

                                      return ListTile(
                                        title: Text('${index + 1} : ${removeAllHtmlTags(route[_m_parent.m_selectedRouteIndex].legs[0].steps[index].html_instructions)}'),
                                        subtitle: Text(removeAllHtmlTags(directionMessage(route[_m_parent.m_selectedRouteIndex].legs[0].steps[index]))),
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


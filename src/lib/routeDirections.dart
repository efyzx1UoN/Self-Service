import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/geoTracker.dart';
import 'routePlanner.dart';
import 'package:flutter_app/routePlanner.dart';
import 'package:flutter_app/route.dart';
import 'package:flutter_app/times.dart';

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

  List<String> getTransitDetails(MapRoute route){
    var stationCounter = 0;
    String startStation, endStation, startTime, endTime, transferMsg;

    List<Steps> steps = route.legs[0].steps;
    for(var i = 0; i < steps.length; i++){
      if(steps[i].travel_mode == "TRANSIT"){
        if(stationCounter == 0){
          startStation = steps[i].transit_details.departure_stop.name;
          startTime = steps[i].transit_details.departure_time.text;
        }
        endStation = steps[i].transit_details.arrival_stop.name;
        endTime = steps[i].transit_details.arrival_time.text;
        stationCounter++;
      }
    }
    if(stationCounter > 1){
      if(stationCounter == 2) {
        transferMsg = "1 transfer";
      }
      else{
        transferMsg = "$stationCounter transfers";
      }
    }
    else{
      transferMsg = "direct";
    }
    List<String> transit_details = List<String>(5);
    transit_details[0] = startStation;
    transit_details[1] = endStation;
    transit_details[2] = startTime;
    transit_details[3] = endTime;
    transit_details[4] = transferMsg;
    return transit_details;
  }


  String directionMessage(Steps step) {
    String string = step.travel_mode+" ";
    switch (step.travel_mode){
      case "TRANSIT": {
        //Converted times for calculating travel time.
        print("STEP: "+step.transit_details.arrival_time.text);
        print("STEP: "+step.transit_details.departure_time.text);
        int dh;
        int dm;
        int ah;
        int am;

        Times dTimes = new Times(step.transit_details.departure_time.text);
        dh = dTimes.hour;
        dm = dTimes.minute;
        print(dTimes.hour.toString() +", "+dTimes.minute.toString());
        Times aTimes = new Times(step.transit_details.arrival_time.text);
        ah = aTimes.hour;
        am = aTimes.minute;
        print(aTimes.hour.toString() +", "+aTimes.minute.toString());

        //int dh = int.parse(step.transit_details.departure_time.text.substring(0,2));
        //int dm = int.parse(step.transit_details.departure_time.text.substring(3,5));
        //int ah = int.parse(step.transit_details.arrival_time.text.substring(0,2));
        //int am = int.parse(step.transit_details.arrival_time.text.substring(3,5));

        int h;
        int m;

        if (dh*60+dm < ah*60+am){ // If there is no overlap to the next day
          int dif = (ah*60 + am) - (dh*60 + dm);
          h = dif ~/ 60;
          m = dif % 60;
        }
        else{
          int dif = (24*60) - (dh*60 + dm) + (ah*60 + am);
          h = dif ~/ 60;
          m = dif % 60;
        }

        string += step.transit_details.headsign
            +" "+h.toString()+"h"+m.toString()+"m\n";
        string += "Departure from ";
        string += step.transit_details.departure_stop.name+": ";
        string += step.transit_details.departure_time.text+"\n";
        string += "Arriving at ";
        string += step.transit_details.arrival_stop.name+": ";
        string += step.transit_details.arrival_time.text+"\n";
        string += step.transit_details.headsign+"\n";
      };
      break;
      case "DRIVING": {string += step.distance.text.toString();} break;
      case "WALKING": {string += step.distance.text.toString();} break;
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
          visible: _m_parent.m_trainVisibility,
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
                                      var transitDetails = getTransitDetails(route[index]);
                                      return Container(
                                        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: <Widget>[
                                              ElevatedButton(
                                                  onPressed: () {
                                                    print('Hello\n\n\n\n\n\n\n\n\n\n\n');
                                                    _m_parent.m_trainVisibility = false;
                                                    _m_parent.m_stepsVisibility = true;
                                                    _m_parent.m_selectedRouteIndex = index;
                                                    _m_parent.removeUnselectedRoutes();
                                                    _m_parent.update();
                                                  },
                                                child: Container(
                                                  padding: const EdgeInsets.only(top: 20.0, bottom: 20 ),
                                                  child: Row(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Icon(Icons.directions_train_sharp, size: 20)
                                                      ),
                                                      Column(
                                                        children: [
                                                          Container(
                                                            alignment: Alignment.topLeft,
                                                            margin: const EdgeInsets.only( left: 5.0),
                                                            child: Text(
                                                              '${transitDetails[2]}',
                                                              style: TextStyle( fontSize: 10.0),
                                                            )
                                                          ),
                                                          Container(
                                                              alignment: Alignment.topLeft,
                                                              margin: const EdgeInsets.only( left: 5.0),
                                                              child: Text(
                                                                '${transitDetails[0]}',
                                                                style: TextStyle( fontSize: 15.0),
                                                              )
                                                          ),
                                                        ]
                                                      ),
                                                      Column(
                                                        children: [
                                                          Container(
                                                              alignment: Alignment.center,
                                                              margin: const EdgeInsets.only( left: 5.0),
                                                              child: Text(
                                                                '${transitDetails[4]}',
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle( fontSize: 10.0, fontStyle: FontStyle.italic),
                                                              )
                                                          ),
                                                          Container(
                                                              alignment: Alignment.center,
                                                              margin: const EdgeInsets.only( left: 5.0),
                                                              child: Text(
                                                                ' ----> ',
                                                                style: TextStyle( fontSize: 15.0),
                                                              )
                                                          ),
                                                          Container(
                                                              alignment: Alignment.center,
                                                              margin: const EdgeInsets.only( left: 5.0),
                                                              child: Text(
                                                                '${route[index].legs[0].duration.text}',
                                                                style: TextStyle( fontSize: 10.0, fontStyle: FontStyle.italic),
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Container(
                                                              alignment: Alignment.topRight,
                                                              margin: const EdgeInsets.only( left: 5.0, right: 5.0),
                                                              child: Text(
                                                                '${transitDetails[3]}',
                                                                style: TextStyle( fontSize: 10.0),
                                                              )
                                                          ),

                                                          Container(
                                                              alignment: Alignment.topRight,
                                                              margin: const EdgeInsets.only( left: 5.0, right: 5.0),
                                                              child: Text(
                                                                '${transitDetails[1]}',
                                                                style: TextStyle( fontSize: 15.0),
                                                              )
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              )
                                            ],
                                          ),),
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
                                              _m_parent.removeUnselectedRoutes();
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
                                        subtitle: Text(removeAllHtmlTags(directionMessage(route[_m_parent.m_selectedRouteIndex].legs[0].steps[index])) +'\n'+ route[_m_parent.m_selectedRouteIndex].legs[0].steps[index].duration.text),
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


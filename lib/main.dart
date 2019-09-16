import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController controller = new MapController();
  double _lat = 51.5;
  double _lon = -1;
  bool showFl = true;
  Geolocator _geolocator;
  Position _position;

  @override
  void initState() {
    super.initState();

    _geolocator = Geolocator();
  }

  void _showHideFl() {
    setState(() {
      showFl = !showFl;
    });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      print(newPosition);

      setState(() {
        _position = newPosition;
        _lat = _position.latitude;
        _lon = _position.longitude;
      });
      controller.move(LatLng(_lat, _lon), controller.zoom);
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build: $_lat $_lon");
    var flButt = !showFl ? null : FloatingActionButton(
      onPressed: updateLocation,
      tooltip: 'UPDATE LOCA~tION',
      child: Icon(Icons.local_drink),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            FlatButton(
              onPressed: () {
                _showHideFl();
              },
              child: Text("Flat Button"),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('($_lat, $_lon).'),
            ),
            Flexible(
              child: FlutterMap(
                mapController: controller,
                options: MapOptions(
                  center: LatLng(_lat, _lon),
                  zoom: 5.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: flButt,
    );
  }
}

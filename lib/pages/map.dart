import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class MapPage extends StatefulWidget {
  const  MapPage({Key? key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
    builder: (context) => const MapPage(),
  );
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
 Position? _currentPosition;
  String _currentAddress = "";
 Map<String, double>? userLocation;
  var placeArray = [];
  String dispLocation = "";
  String dispCurrent = "";

  _setLastLocation(lat,long,address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('lat', lat);
    await prefs.setDouble('long', long);
    await prefs.setString('address', address);
    setState(() {
      dispLocation = '';
    });
  }

  _getLastLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dispLocation = 'Last coordinates LAT: ${prefs.getDouble('lat')}, LNG: ${prefs.getDouble('long')}, Address: ${prefs.getString('address')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
                child: const Text("Get location"),
                onPressed: () {
                  _getCurrentLocation();
                }),
              Text(dispCurrent),
              if (_currentPosition != null) ElevatedButton(
                child: const Text("Save current location"),
                onPressed: () {
                  _setLastLocation(_currentPosition?.latitude,_currentPosition?.longitude,_currentAddress);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Saved LAT: ${_currentPosition?.latitude}, LNG: ${_currentPosition?.longitude}')));
                }),
            ElevatedButton(
                child: const Text("Get saved location"),
                onPressed: () {
                  _getLastLocation();
                }),
            Text(dispLocation),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    // LocationPermission permission = await Geolocator.requestPermission();
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
       _getAddressFromLatLng();
      });
      }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        // 52.815310,-2.214990
        _currentPosition!.latitude,
          _currentPosition!.longitude 
      );
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.country}, ${place.postalCode}";
       dispCurrent = "LAT: ${_currentPosition?.latitude}, LNG: ${_currentPosition?.longitude}, current address is $_currentAddress";
      });
    } catch (e) {
      print(e);
    }
  }
}

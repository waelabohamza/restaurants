import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  // Start geolooctor

  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  // Position _currentPosition;
  // String _currentAddress;

  // _getCurrentLocation() {
  //   geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //     print("=======================================") ; 
  //     print(_currentPosition.latitude) ; 
  //     print("=======================================") ; 
  //         _getAddressFromLatLng()  ; 
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
  //  _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);

  //     Placemark place = p[0];

  //     setState(() {
  //       _currentAddress =
  //           "${place.locality}, ${place.postalCode}, ${place.country}";
  //           print("=======================================") ; 
  //           print(_currentAddress) ; 
  //          print("=======================================") ; 

  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // End geolocator
  @override
  void initState() {
    //  _getCurrentLocation() ;

    // TODO: implement initState
    super.initState();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  List<Marker> markers = [
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(37.42796133180664, -122.085749650962),
        infoWindow: InfoWindow(title: "this is place one "))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dropdown Menu Button JSON")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: markers.toSet(),
                onTap: _handleTap,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleTap(LatLng tappedpoint) {
    setState(() {
      markers = [];
      markers.add(
        Marker(
            markerId: MarkerId(tappedpoint.toString()),
            infoWindow: InfoWindow(title: tappedpoint.toString()),
            position: tappedpoint,
            draggable: true,
            onDragEnd: (ondragend) {
              print(ondragend);
            }),
      );
    });
    print(tappedpoint);
  }
}

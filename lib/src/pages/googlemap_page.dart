import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  State<GoogleMapPage> createState() => GoogleMapPageState();
}

class GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();

  var _initLocation = CameraPosition(target: LatLng(13.747218, 100.534967));
  Set<Marker> maskers = {};
  StreamSubscription<LocationData> _locationSubscription;
  /*static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);*/
  @override
  void initState() {
    trackingLocation();
    // TODO: implement initState
    super.initState();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),

      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _initLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              addMarker("a1", LatLng(13.6972552, 100.5131413), "map title",
                  "map sub title");
              animateCamera(LatLng(13.6972552, 100.5131413), 14);
              setState(() {});
            },
            markers: maskers,

          ),
          _buildActionButton()
        ],
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),*/

    );

  }

  Future<void> addMarker(String keyId, LatLng position, String title, String subTitle) async {

    final Uint8List markerIcon = await getBytesFromAsset("assets/images/header_1.png", 150);
    final BitmapDescriptor bitmap = BitmapDescriptor.fromBytes(markerIcon);
    Marker masker = Marker(
      icon: bitmap,
      markerId: MarkerId(keyId),
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: subTitle,
        onTap: (){
          _launchMaps(lat: position.latitude , lng: position.longitude);
        },
      ),
    );
    maskers.add(masker);
  }

  Future<void> animateCamera(LatLng latLng, double zoom) async {
    var map = await _controller.future;
    map.animateCamera(CameraUpdate.newLatLngZoom(latLng, zoom));
  }

  trackingLocation() async {
    if (_locationSubscription != null) {
      setState(() {
        // show dialog
        _locationSubscription.cancel();
        _locationSubscription = null;
        maskers?.clear();
      });
    } else {
      final Location _locationService = Location();

      await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH,
        interval: 10000,
        distanceFilter: 100,
      ); // meters.

      try {

        if (await _locationService.serviceEnabled()) {
          if (await _locationService.requestPermission() == PermissionStatus.GRANTED) {
            _locationSubscription = _locationService.onLocationChanged().listen(
                  (LocationData result) async {
                maskers?.clear();
                final latLng = LatLng(result.latitude, result.longitude);
                await addMarker(
                  result.time.toString(),
                  latLng,
                  "dddd",
                  "ffffff",
                );

                setState(() {
                  animateCamera(latLng, 14);
                });
              },
            );
          } else {
            print('Permission denied');
          }
        } else {
          bool serviceStatusResult = await _locationService.requestService();
          print("Service status activated after request: $serviceStatusResult");
          if (serviceStatusResult) {
            trackingLocation();
          } else {
            print('Service denied');
          }
        }
      } on PlatformException catch (e) {
        print('trackingLocation error: ${e.message}');

        if (e.code == 'PERMISSION_DENIED') {
          return print('Permission denied');
        }

        if (e.code == 'SERVICE_STATUS_ERROR') {
          return print('Service error');
        }
      }
    }
  }
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }


  _launchMaps({double lat, double lng}) async {
    // Set Google Maps URL Scheme for iOS in info.plist (comgooglemaps)

    const googleMapSchemeIOS = 'comgooglemaps://';
    const googleMapURL = 'https://maps.google.com/';
    const appleMapURL = 'https://maps.apple.com/';
    final parameter = '?z=16&q=$lat,$lng';

    if(Platform.isAndroid){
      if (await canLaunch(googleMapURL)) {
        return await launch(googleMapURL + parameter);
      }
    }else{
      if (await canLaunch(googleMapSchemeIOS)) {
        return await launch(googleMapSchemeIOS + parameter);
      }

      if (await canLaunch(appleMapURL)) {
        return await launch(appleMapURL + parameter);
      }
    }







    throw 'Could not launch url';
  }





  Container _buildActionButton() {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 70, right: 12),
      child: Column(
        children: <Widget>[
          FloatingActionButton(
            heroTag: "a1",
            child: Icon(Icons.gps_fixed),
            backgroundColor: _locationSubscription != null ? Colors.red : null,
            onPressed: () {
              trackingLocation();
            },
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "a2",
            child: Icon(Icons.pin_drop),
            onPressed: () async {
              final latLng = LatLng(13.7469319, 100.5327996);
              await addMarker("dummy-01", latLng, "map title", "map sub title");

              setState(() {
                animateCamera(latLng, 14);
              });
            },
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "a3",
            child: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                maskers?.clear();
              });
            },
          ),
        ],
      ),
    );
  }
//  Future<void> _goToTheLake() async {
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guide_me/controller/PlacesController.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

import 'package:guide_me/controller/Locationcontroler.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key});

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  GoogleMapController? _controller;
  bool isvisible = false;
  Set<Marker> _markers = {};
  Locationcontroler locationcontroler = Get.find<Locationcontroler>();
  Placescontroller placescontroller = Get.find<Placescontroller>();
  LatLng? selectedlatLng;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _setCustomMarkers();
    super.initState();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _setCustomMarkers() async {
    Uint8List markerIconBytes =
        await getBytesFromAsset('assets/logo/point.png', 150);
    Uint8List historyIconBytes =
        await getBytesFromAsset('assets/images/history.png', 150);
    Uint8List naturalIconBytes =
        await getBytesFromAsset('assets/images/natural.png', 150);
    Uint8List funIconBytes =
        await getBytesFromAsset('assets/images/fun.png', 150);
    Uint8List artIconBytes =
        await getBytesFromAsset('assets/images/art.png', 150);
    Uint8List gastronomyIconBytes =
        await getBytesFromAsset('assets/images/gastronomy.png', 150);

    BitmapDescriptor customMarker = BitmapDescriptor.fromBytes(markerIconBytes);
    BitmapDescriptor historyMarker =
        BitmapDescriptor.fromBytes(historyIconBytes);
    BitmapDescriptor naturalMarker =
        BitmapDescriptor.fromBytes(naturalIconBytes);
    BitmapDescriptor funMarker = BitmapDescriptor.fromBytes(funIconBytes);
    BitmapDescriptor artMarker = BitmapDescriptor.fromBytes(artIconBytes);
    BitmapDescriptor gastronomyMarker =
        BitmapDescriptor.fromBytes(gastronomyIconBytes);

    Set<Marker> markers = {};

    print("Değer var sanırım ${placescontroller.places}");
    for (int i = 0; i < placescontroller.places.length; i++) {
      print("salak mısın ${placescontroller.places[i]}");
      var place = placescontroller.places[i];
      print("Değer var sanırım ${place['position'][0]}");

      // Switch-case yapısı ile icon seçimi
      BitmapDescriptor selectedIcon;
      switch (place['placespecies']) {
        case 'Tarihi ve Kültürel Yerler':
          selectedIcon = historyMarker;
          break;
        case 'Doğa ve Açık Hava Aktiviteleri':
          selectedIcon = naturalMarker;
          break;
        case 'Eğlence ve Rekreasyon':
          selectedIcon = funMarker;
          break;
        case 'Sanat ve Mimari':
          selectedIcon = artMarker;
          break;
        case 'Gastronomi ve Yerel Lezzetler':
          selectedIcon = gastronomyMarker;
          break;
        default:
          selectedIcon = customMarker;
          break;
      }

      markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: LatLng(place['position'][0], place['position'][1]),
          icon: selectedIcon,
          infoWindow: InfoWindow(
            title: place['placeName'],
            snippet: place['placeDescription'],
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _controller = controller;
                });
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  36.89619029140674,
                  30.712865442713063,
                ),
                zoom: 14.0,
              ),
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              compassEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              markers: _markers,
              onLongPress: (LatLng latLng) {
                setState(() {
                  selectedlatLng = latLng;
                  isvisible = true;
                  _markers = {
                    Marker(
                      markerId: MarkerId(latLng.toString()),
                      position: latLng,
                    ),
                  };
                });
              },
            ),
          ),
          Visibility(
            visible: isvisible,
            child: Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 30, 129, 176),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (selectedlatLng != null) {
                    placescontroller.setPlacePosition(selectedlatLng!);

                    Get.back();
                  }
                },
                child: Text(
                  'Konumu işaretle',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: widget.initialPosition,
//           zoom: 14.0,
//         ),
//         onMapCreated: (GoogleMapController controller) {
//           // Harita oluşturulduğunda yapılacak işlemler
//         },
//         onLongPress: (LatLng latLng) {
//           setState(() {
//             _markers.clear();
//             _markers.add(
//               Marker(
//                 markerId: MarkerId(latLng.toString()),
//                 position: latLng,
//               ),
//             );
//           });
//           widget.onLocationSelected(latLng);
//         },
//         markers: _markers,
//       ),

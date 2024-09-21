import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guide_me/controller/Locationcontroler.dart';
import 'package:guide_me/controller/PlacesController.dart';
import 'package:guide_me/screens/FullScreenImagePage.dart';
import 'package:guide_me/screens/FullScreenMap.dart';
import 'package:guide_me/widgets/Button.dart';
import 'package:guide_me/widgets/Textwidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LocationAdminPage extends StatefulWidget {
  const LocationAdminPage({super.key});

  @override
  State<LocationAdminPage> createState() => _LocationAdminPageState();
}

class _LocationAdminPageState extends State<LocationAdminPage> {
  Placescontroller placescontroller = Get.find<Placescontroller>();
  final TextEditingController placeNameEditingController =
      TextEditingController();
  final TextEditingController placeDescriptionEditingController =
      TextEditingController();
  Locationcontroler locationcontroler = Get.find<Locationcontroler>();
  GoogleMapController? _controller;
  final bool _isLoading = true;

  // Başlangıç koordinat
  // Konumun daha önce alınıp alınmadığını kontrol eden değişken
  String _selectedItem = 'Tarihi ve Kültürel Yerler'; // Başlangıç değeri

  @override
  void initState() {
    placescontroller.getPlace();
    super.initState();
    _setCustomMarkers();
  }

  final List<LatLng> _markerPositions = [
    const LatLng(36.89188085117299, 30.709979943931106), // İlk konum
    const LatLng(45.532888, -122.690000), // İkinci konum
    const LatLng(45.530342, -122.650000), // Üçüncü konum
  ];
  final Set<Marker> _markers = {};
  void _setCustomMarkers() async {
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(0, 0)), // İkonun boyutu
      'assets/flags/tr.png', // Özel simgenin asset yolu
    );

    for (int i = 0; i < _markerPositions.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: _markerPositions[i],
          icon: customIcon,
          infoWindow: InfoWindow(
            title: 'Nokta ${i + 1}',
            snippet: 'Özel simge ile gösterilen konum.',
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    placeNameEditingController.dispose();
    placeDescriptionEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: SizedBox(
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "Yer Ekleyin",
                  style: GoogleFonts.inter(
                      fontSize: 23, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 90.w,
                child: TextFieldWidget(
                    placeholder: "Yer Adı",
                    hintText: "Yer adı girin ",
                    obsoureText: false,
                    textEditingController: placeNameEditingController),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 90.w,
                child: TextFieldWidget(
                    placeholder: "Yer Açıklaması",
                    hintText: "Yer açıklaması girin",
                    obsoureText: false,
                    textEditingController: placeDescriptionEditingController),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () => {},
                    child: SizedBox(
                      width: 90.w,
                      child: Text(
                        "Kapak Fotoğrafı",
                        style: GoogleFonts.inter(fontSize: 18),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomsheet(context);
                    },
                    child: Obx(
                      () => Container(
                          width: 90.w,
                          height: 180,
                          decoration: BoxDecoration(
                            image: placescontroller.filePath.value.isNotEmpty
                                ? DecorationImage(
                                    image: FileImage(
                                      File(placescontroller.filePath.value),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: placescontroller.filePath.value.isNotEmpty
                              ? null
                              : Center(
                                  child: SizedBox(
                                    height: 75,
                                    width: 75,
                                    child:
                                        Image.asset('assets/images/photo.png'),
                                  ),
                                )),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 90.w,
                    child: Text(
                      "Konum",
                      style: GoogleFonts.inter(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                      height: 24.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Obx(
                        () {
                          return locationcontroler.currentposition.value == null
                              ? const Center(child: Text('Konum alınamadı.'))
                              : Stack(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        width: 90.w,
                                        height: 200,
                                        child: GoogleMap(
                                          onMapCreated: (GoogleMapController
                                              googleMapController) {
                                            setState(() {
                                              _controller = googleMapController;
                                            });
                                          },
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                locationcontroler
                                                    .currentposition
                                                    .value
                                                    .latitude,
                                                locationcontroler
                                                    .currentposition
                                                    .value
                                                    .longitude),
                                            zoom: 14.0,
                                          ),
                                          scrollGesturesEnabled: true,
                                          zoomGesturesEnabled: true,
                                          tiltGesturesEnabled: true,
                                          rotateGesturesEnabled: true,
                                          compassEnabled: true,
                                          myLocationEnabled: true,
                                          myLocationButtonEnabled: true,
                                          markers: _markers,
                                        )),
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => FullScreenMap());
                                      },
                                      child: Container(
                                        height: 200,
                                        width: 90.w,
                                        color: Colors.transparent,
                                      ),
                                    )
                                  ],
                                );
                        },
                      )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  SizedBox(
                    width: 90.w,
                    child: Text(
                      "Gezilcek Yerin Türü",
                      style: GoogleFonts.inter(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: 90.w, // ScreenUtil ile uyumlu genişlik
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DropdownButton<String>(
                          value: _selectedItem,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItem = newValue!;
                            });
                          },
                          isExpanded:
                              true, // Dropdown menünün genişliğini Container ile uyumlu yapar
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.black), // Simgeler
                          underline: const SizedBox(), // Alt çizgi kaldırıldı
                          items: <String>[
                            'Tarihi ve Kültürel Yerler',
                            'Doğa ve Açık Hava Aktiviteleri',
                            'Eğlence ve Rekreasyon',
                            'Sanat ve Mimari',
                            'Gastronomi ve Yerel Lezzetler'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              MainButton(
                  text: 'Kaydet',
                  onPressed: () {
                    placescontroller
                        .setPlaceName(placeNameEditingController.text);
                    placescontroller.setPlaceDescription(
                        placeDescriptionEditingController.text);
                    placescontroller.setPlaceSpecies(_selectedItem);
                    placescontroller.savePlace();

                    placeNameEditingController.clear();
                    placeDescriptionEditingController.clear();
                  },
                  isLoading: false)
            ],
          ),
        ),
      )),
    );
  }

  Future showModalBottomsheet(BuildContext contex) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 240,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.remove_red_eye_outlined),
                title: const Text(" Resmi görüntüle"),
                onTap: () {
                  // use get to navigate to the full screen image page
                  Get.to(() => FullScreenImagePage(
                      imageUrl: placescontroller.filePath.value));
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamerayı Aç"),
                onTap: () {
                  Get.back();
                  placescontroller.requestCameraPermission(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Galeriden Seç"),
                onTap: () {
                  Get.back();
                  placescontroller.requestGalleryPermission(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Profil Resmini Sil"),
                onTap: () {
                  placescontroller.setFilePath("");
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

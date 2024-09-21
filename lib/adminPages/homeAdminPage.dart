import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guide_me/controller/Locationcontroler.dart';
import 'package:guide_me/controller/PlacesController.dart';
import 'package:guide_me/widgets/CategoryButton.dart';
import 'package:guide_me/widgets/PlacesCard.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  Placescontroller placescontroller = Get.find<Placescontroller>();
  Locationcontroler locationcontroler = Get.find<Locationcontroler>();

  @override
  void initState() {
    placescontroller.getPlace();
    super.initState();
  }

  //   PlacesCard(
  //       title: "Side Antik Kenti",
  //       image: "assets/images/side.png",
  //       description:
  //           "Antalya'nın Manavgat ilçesinde yer alan antik bir kenttir. Helenistik ve Roma dönemlerinde önemli bir ticaret merkezi ve liman şehri olarak bilinir. Günümüzde turistler için popüler bir ziyaret noktasıdır."),
  //   PlacesCard(
  //       title: "Perge Anıtsal Çeşme",
  //       image: "assets/images/anitsalcesme.png",
  //       description:
  //           "Side antik kentindeki anıtsal çeşme, Helenistik dönemde yapılmış büyük bir su yapıtıdır. Şehrin merkezinde bulunur ve Roma döneminde değişiklikler geçirmiştir."),
  //   PlacesCard(
  //       title: "Side sütunlu Cadde",
  //       image: "assets/images/sutunlucadde.png",
  //       description:
  //           "Side antik kentindeki sütunlu cadde, Helenistik dönemde yapılmış önemli bir cadde yapıtıdır. Şehrin merkezinde uzanır ve Roma döneminde de kullanılmıştır."),
  //   PlacesCard(
  //       title: "Bizans Hastanesi",
  //       image: "assets/images/bizanshastenesi.png",
  //       description: ""),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100.w,
                height: 14.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => {
                          print(
                              "işste o sayı${placescontroller.places.length}"),
                        },
                        child: Text(
                          "Kategoriler",
                          style: GoogleFonts.inter(
                              fontSize: 22, fontWeight: FontWeight.w200),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            CategoryButton(
                                text: "Tarihi ve Kültürel Yerler",
                                onPressed: () => {}),
                            CategoryButton(
                                text: "Doğa ve Açık Hava Aktiviteleri",
                                onPressed: () => {}),
                            CategoryButton(
                                text: "Eğlence ve Rekreasyon",
                                onPressed: () => {}),
                            CategoryButton(
                                text: "Sanat ve Mimari", onPressed: () => {}),
                            CategoryButton(
                                text: "Gastronomi ve Yerel Lezzetler",
                                onPressed: () => {}),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 100.w,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Bana en yakın yerler",
                      style: GoogleFonts.inter(
                          fontSize: 22, fontWeight: FontWeight.w200)),
                ),
              ),
              Obx(
                () {
                  if (placescontroller.places.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap:
                          true, // This is important to avoid the unbounded height error
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                      itemCount: placescontroller.places.length,
                      itemBuilder: (context, index) {
                        LatLng startPoint = LatLng(
                            locationcontroler.currentposition.value.latitude,
                            locationcontroler
                                .currentposition.value.longitude); // İstanbul
                        LatLng endPoint = LatLng(
                            placescontroller.places[index]['position'][0],
                            placescontroller.places[index]['position']
                                [1]); // New York
                        print(
                            "yerin adı ${placescontroller.places[index]['placeName']}");
                        double distance =
                            calculateDistance(startPoint, endPoint);
                        var place = placescontroller.places[index];
                        return PlacesCard(
                            uid: place['uid'],
                            title: place['placeName'],
                            distance: distance.toString(),
                            image: place['imageUrl'],
                            description: place['placeDescription']);
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  double calculateDistance(LatLng startPoint, LatLng endPoint) {
    double distanceInMeters = Geolocator.distanceBetween(startPoint.latitude,
        startPoint.longitude, endPoint.latitude, endPoint.longitude);
    double distanceInKm = distanceInMeters / 1000;
    double distanceRounded = double.parse(distanceInKm.toStringAsFixed(2));
    return distanceRounded;
  }
}

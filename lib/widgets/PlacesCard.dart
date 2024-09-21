import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_me/NavigationPages/chooseGuide.dart';
import 'package:guide_me/adminPages/chooseGuideAdmin.dart';
import 'package:guide_me/controller/audiocontroller.dart';
import 'package:guide_me/controller/user.dart';
import 'package:guide_me/screens/audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PlacesCard extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final String distance;
  final String uid;

  const PlacesCard(
      {super.key,
      required this.title,
      required this.image,
      required this.description,
      required this.distance,
      required this.uid});

  @override
  _PlacesCardState createState() => _PlacesCardState();
}

class _PlacesCardState extends State<PlacesCard> {
  UserController userController = Get.find<UserController>();
  Audiocontroller audiocontroller = Get.find<Audiocontroller>();
  @override
  void initState() {
    Get.put(Audiocontroller());
    audiocontroller.setUid(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (userController.role.value == "user") {
            Get.to(() => ChooseGuide(
                  uid: widget.uid,
                ));
          } else {
            Get.to(() => Chooseguideadmin(
                  uid: widget.uid,
                ));
          }
        },
        child: Container(
          width: 100.w,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: const Color.fromARGB(200, 30, 129, 176), width: 2),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // Gölgenin konumu
                ),
              ]),
          child: Column(
            children: [
              Text(
                widget.title,
                style: GoogleFonts.inter(
                    fontSize: 20,
                    color: const Color.fromARGB(200, 30, 129, 176)),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 92.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            widget.image,
                            width: 50.w, // Görselin genişliği sabit kalıyor.
                            height: 20.h,
                            fit: BoxFit.cover, // Görselin taşmasını engeller.
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Flexible(
                            // Bu widget, metin kısmının taşmasını engeller.
                            child: SizedBox(
                              width: 35.w,
                              height: 20.h,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mesafe :${widget.distance} Km",
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "Açıklama : ${widget.description}",
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

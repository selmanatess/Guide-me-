import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_me/controller/Locationcontroler.dart';
import 'package:guide_me/controller/photo.dart';
import 'package:guide_me/controller/user.dart';

import 'package:guide_me/screens/FullScreenImagePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guide_me/widgets/ChangePassword.dart';

import 'package:image_picker/image_picker.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  final UserController userController = Get.find<UserController>();
  final PhotoController photoController = Get.find<PhotoController>();
  Map<String, dynamic> UserInfo = {};
  final TextEditingController _phoneController = TextEditingController();
  bool isEditing = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20),
        // Profil resmi
        Stack(
          children: [
            InkWell(onTap: () {
              showModalBottomsheet(context);
            }, child: Obx(
              () {
                return Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                    //shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: photoController.filepath.value.isEmpty
                          ? const AssetImage(
                              'assets/images/default_profile.png')
                          : FileImage(File(photoController.filepath.value)),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            )),
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () {
                  showModalBottomsheet(context);
                },
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.pen,
                    color: Color.fromARGB(255, 34, 151, 206),
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  userController.name.value,
                  style: GoogleFonts.inter(
                      fontSize: 24, fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 46.w,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "E mail",
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(
                                () {
                                  return Container(
                                    child: Text(
                                      userController.email.value,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 15,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Abonelik",
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(
                                () {
                                  return Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          userController.subscribe == ''
                                              ? "Abonelik Yok"
                                              : userController.subscribe.value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {},
                                          child: const Icon(
                                            FontAwesomeIcons.pen,
                                            color: Color.fromARGB(
                                                255, 34, 151, 206),
                                            size: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 45.w,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "Telefon",
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(
                                () {
                                  return Container(
                                    child: Row(
                                      children: [
                                        isEditing
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    width: 110,
                                                    height: 30,
                                                    child: TextFormField(
                                                      controller:
                                                          _phoneController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: "Telefon No",
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isEditing = !isEditing;
                                                      });
                                                      userController.setPhone(
                                                          _phoneController
                                                              .text);
                                                    },
                                                    child: const Icon(
                                                      FontAwesomeIcons.check,
                                                      color: Color.fromARGB(
                                                          255, 34, 151, 206),
                                                      size: 19,
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    userController
                                                                .phone.value ==
                                                            ''
                                                        ? "Numara Yok"
                                                        : userController
                                                            .phone.value,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isEditing = !isEditing;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      FontAwesomeIcons.pen,
                                                      color: Color.fromARGB(
                                                          255, 34, 151, 206),
                                                      size: 15,
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        //listtile for logout

        listTile("Gezdiğim yerler", Icons.location_on, () {
          Get.find<Locationcontroler>().getCurrentLocation();
        }),
        listTile("Şifre değiştir", FontAwesomeIcons.lock, () {
          Get.to(() => const Changepassword());
        }),
        listTile("Uygulama Dili", Icons.language, () => {}),
        listTile("Çıkış Yap", Icons.logout, () {
          userController.signOut();
        }),
      ]),
    );
  }

  Widget listTile(String title, IconData icon, Function onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 34, 151, 206)),
        title: Text(title),
        onTap: () {
          onTap();
        },
      ),
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
                title: const Text("Profil Resmini görüntüle"),
                onTap: () {
                  // use get to navigate to the full screen image page
                  Get.to(() => FullScreenImagePage(
                      imageUrl: photoController.filepath.value));
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamerayı Aç"),
                onTap: () {
                  Get.back();
                  photoController.requestCameraPermission(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Galeriden Seç"),
                onTap: () {
                  Get.back();
                  photoController.requestGalleryPermission(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Profil Resmini Sil"),
                onTap: () {
                  Get.back();
                  photoController.deletePathphoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:guide_me/NavigationPages/AccountPage.dart';
import 'package:guide_me/NavigationPages/GuidesPage.dart';
import 'package:guide_me/NavigationPages/HomePage.dart';
import 'package:guide_me/NavigationPages/LocationPage.dart';
import 'package:guide_me/adminPages/AccountAdminPage.dart';
import 'package:guide_me/adminPages/GuidesAdminPage.dart';
import 'package:guide_me/adminPages/LocationAdminPage.dart';
import 'package:guide_me/adminPages/homeAdminPage.dart';

import 'package:guide_me/controller/Locationcontroler.dart';
import 'package:guide_me/controller/PlacesController.dart';
import 'package:guide_me/controller/audiocontroller.dart';
import 'package:guide_me/controller/photo.dart';
import 'package:guide_me/controller/user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final UserController userController = Get.find<UserController>();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _widgetOptions = [];
  final String _role = 'user'; // Varsayılan rol
  List<Widget> adminWidgetOptions = <Widget>[
    const HomeAdminPage(),
    const LocationAdminPage(),
    const Guidesadminpage(),
    const AccountAdminPage(),
  ];
  List<Widget> userwidgetOptions = <Widget>[
    const HomePageNavigation(),
    const LocationPage(),
    const AsistansPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _pageController.jumpToPage(index);
  }

  final photoController = Get.find<PhotoController>();
  @override
  void initState() {
    photoController.fetchPhoto();
    super.initState();
    Get.put(Audiocontroller());

    Get.put(Locationcontroler());
    Get.put(Placescontroller());
    userController.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        actions: [
          Container(
            width: 100.w,
            height: 15.h,
            decoration: const BoxDecoration(
              color: Color.fromARGB(200, 30, 129, 176),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 70, child: const Text("")),
                  Image.asset(
                    'assets/logo/mainlogo.png',
                    width: 20.w,
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: () {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      auth.signOut();
                      Get.offAllNamed('/promotion');
                    },
                    child: Obx(() => SizedBox(
                          width: 50,
                          height: 50,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: photoController
                                    .filepath.value.isEmpty
                                ? const AssetImage(
                                    'assets/images/default_profile.png')
                                : FileImage(File(photoController.filepath
                                    .value)), // Replace with actual image source
                          ),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (userController.role.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (userController.role.value == 'admin') {
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: userController.role.value == 'admin'
                ? adminWidgetOptions
                : userwidgetOptions,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          );
        } else {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: userwidgetOptions,
          );
        }
      }),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GNav(
            onTabChange: _onItemTapped,
            color: Colors.grey[600],
            backgroundColor: Colors.white,
            selectedIndex: _selectedIndex,
            activeColor: const Color.fromARGB(200, 30, 129, 176),
            iconSize: 24.sp,
            tabBackgroundColor: Colors.grey.shade300,
            tabBorderRadius: 20,
            padding: const EdgeInsets.all(16),
            gap: 20,
            tabs: const [
              GButton(icon: Icons.home, text: 'Ana Sayfa'),
              GButton(icon: Icons.location_on, text: 'Konum'),
              GButton(icon: Icons.record_voice_over_rounded, text: 'Rehberler'),
              GButton(icon: Icons.person, text: 'Hesap'),
            ],
          ),
        ),
      ),
    );
  }
}

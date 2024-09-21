import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:guide_me/authCheck.dart';
import 'package:guide_me/controller/photo.dart';
import 'package:guide_me/controller/showAlert.dart';
import 'package:guide_me/controller/user.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:guide_me/firebase_options.dart';
import 'package:guide_me/screens/FullScreenMap.dart';
import 'package:guide_me/screens/MainPage.dart';
import 'package:guide_me/screens/loginScreen.dart';
import 'package:guide_me/screens/promotion.dart';
import 'package:guide_me/screens/promotion1.dart';
import 'package:guide_me/screens/promotion2.dart';
import 'package:guide_me/screens/signUpScreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.debug);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        getPages: [
          GetPage(name: '/', page: () => const Mainpage()),
          GetPage(name: '/signUp', page: () => Signupscreen()),
          GetPage(name: '/login', page: () => const LoginScreen()),
          GetPage(name: '/promotion', page: () => const Promotion()),
          GetPage(name: '/promotion1', page: () => const Promotion1()),
          GetPage(name: '/promotion2', page: () => const Promotion2()),
          GetPage(name: '/locationPage', page: () => FullScreenMap()),
        ],
        title: 'Guide Me',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthCheck(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

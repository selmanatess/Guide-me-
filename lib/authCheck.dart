import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:guide_me/controller/photo.dart';
import 'package:guide_me/controller/showAlert.dart';
import 'package:guide_me/controller/user.dart';
import 'package:guide_me/screens/MainPage.dart';
import 'package:guide_me/screens/loginScreen.dart';
import 'package:guide_me/screens/promotion.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    Get.put(UserController());
    Get.put(Showalert());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final userController = Get.find<UserController>();
        if (userController.isLoading.isTrue) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (userController.user.value != null) {
            Get.put(PhotoController());
            return const Mainpage();
          } else {
            return const Promotion();
          }
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_me/adminPages/AccountAdminPage.dart';
import 'package:guide_me/screens/shortscreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abonelik Seç"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //container for the title
              SizedBox(
                height: 8.h,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => Shortscreen());
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromARGB(200, 30, 129, 176),
                          width: 2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // Gölgenin konumu
                        ),
                      ]),
                  width: 90.w,
                  height: 15.h,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Free plan",
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Ücretsiz olarak  rehberi kısıtlı rotalarla dinleyebilirsiniz.",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(200, 30, 129, 176),
                        width: 2),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // Gölgenin konumu
                      ),
                    ]),
                width: 90.w,
                height: 15.h,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Plan 1",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Daha fazla rotayı dinleyebilirsiniz.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(200, 30, 129, 176),
                        width: 2),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // Gölgenin konumu
                      ),
                    ]),
                width: 90.w,
                height: 15.h,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Plan 2",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "istediğiniz  rotayı en detayına kadar  dinleyebilirsiniz.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

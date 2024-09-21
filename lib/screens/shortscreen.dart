import 'package:flutter/material.dart';
import 'package:guide_me/adminPages/AccountAdminPage.dart';
import 'package:guide_me/widgets/PlayerWidget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Shortscreen extends StatefulWidget {
  const Shortscreen({super.key});

  @override
  State<Shortscreen> createState() => _ShortscreenState();
}

class _ShortscreenState extends State<Shortscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rehberi dinliyorsunuz"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //container for the title
              Container(
                width: 100.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/canerhoca%2FIMG-20240906-WA0004.jpg?alt=media&token=0a4fe716-1103-401a-b7c9-af4534cb4496"),
                            fit: BoxFit.cover,
                          ),
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
                      padding: const EdgeInsets.all(8.0),
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      height: 25.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/canerhoca%2FIMG-20240906-WA0005.jpg?alt=media&token=0887ecb5-58f3-4e53-85fa-c5037bb4d9f0"),
                            fit: BoxFit.cover,
                          ),
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
                      padding: const EdgeInsets.all(8.0),
                    )
                  ],
                ),
              ),
              PlayerWidget(
                  img: "assets/profile/caner.png",
                  name: "Caner",
                  audio:
                      "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/mp3_files%2Fcaner%20plan%201.mp3?alt=media&token=09cd1c6f-d3a9-4519-9aa4-39d7f08949ed"),
              Container(
                width: 100.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/canerhoca%2FIMG-20240906-WA0006.jpg?alt=media&token=f3d017b5-a1fa-43f9-a0f5-fa378812c7c2"),
                            fit: BoxFit.cover,
                          ),
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
                      padding: const EdgeInsets.all(8.0),
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      height: 25.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/canerhoca%2FIMG-20240906-WA0007.jpg?alt=media&token=006fd735-f16b-4ee9-8386-97652d6c3d3a"),
                            fit: BoxFit.cover,
                          ),
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
                      padding: const EdgeInsets.all(8.0),
                    )
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

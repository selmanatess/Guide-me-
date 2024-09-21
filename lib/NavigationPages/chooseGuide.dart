import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_me/controller/audiocontroller.dart';
import 'package:guide_me/screens/subscribeScreen.dart';
import 'package:guide_me/widgets/PlayerWidget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class ChooseGuide extends StatefulWidget {
  final String uid;

  const ChooseGuide({super.key, required this.uid});

  @override
  State<ChooseGuide> createState() => _ChooseGuideState();
}

class _ChooseGuideState extends State<ChooseGuide> {
  Audiocontroller audiocontroller = Audiocontroller();
  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    audiocontroller.intrdownloadMp3();
    super.initState();

    // Start the player as soon as the app is displayed.
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();

    super.dispose();
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
                      SizedBox(
                          width: 70,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 25.sp,
                            ),
                            onPressed: () => {Navigator.pop(context)},
                          )),
                      Image.asset(
                        'assets/logo/mainlogo.png',
                        width: 20.w,
                        height: 10.h,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/images/default_profile.png'),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => {Get.to(() => SubscribeScreen())},
                  child: Text(
                    "Lütfen Rehber Seçiniz",
                    style: GoogleFonts.inter(
                        fontSize: 25, fontWeight: FontWeight.w200),
                  ),
                ),
              ),
              Column(
                children: List.generate(
                  audiocontroller.intro.length,
                  (index) {
                    return PlayerWidget(
                      name: audiocontroller.intro[index]['name'].split(' ')[0],
                      img: audiocontroller.intro[index]['picUrl'],
                      audio: audiocontroller.intro[index]['audio'],
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
//  PlayerWidget(
//                   img: "assets/profile/caner.png",
//                   name: "Caner",
//                   audio: "audio/caner.mp3"),
//               PlayerWidget(
//                   img: "assets/profile/sila.png",
//                   name: "Sıla",
//                   audio: "audio/sila.mp3"),
//               PlayerWidget(
//                   img: "assets/profile/yusuf.png",
//                   name: "Yusuf",
//                   audio: "audio/yusuf.mp3"),
//               PlayerWidget(
//                   img: "assets/profile/ismet.png",
//                   name: "İsmet",
//                   audio: "audio/ismet.mp3"),
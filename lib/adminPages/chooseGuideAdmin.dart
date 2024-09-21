import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_me/controller/audiocontroller.dart';
import 'package:guide_me/screens/audio.dart';
import 'package:guide_me/widgets/PlayerWidget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Chooseguideadmin extends StatefulWidget {
  String uid;

  Chooseguideadmin({super.key, required this.uid});

  @override
  State<Chooseguideadmin> createState() => _ChooseguideadminState();
}

class _ChooseguideadminState extends State<Chooseguideadmin> {
  // Remove the duplicate declaration of 'audiocontroller'
  late AudioPlayer player = AudioPlayer();
  Audiocontroller audiocontroller = Get.find<Audiocontroller>();
  @override
  void initState() {
    super.initState();
    audiocontroller.setUid(widget.uid);
    audiocontroller.intrdownloadMp3();
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
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "İntro Sesi Ekleyin",
                    style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),

                // Replace ListView.builder with a Column and map the items
                Column(
                  children: List.generate(
                    audiocontroller.intro.length,
                    (index) {
                      return PlayerWidget(
                        name:
                            audiocontroller.intro[index]['name'].split(' ')[0],
                        img: audiocontroller.intro[index]['picUrl'],
                        audio: audiocontroller.intro[index]['audio'],
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(200, 30, 129, 176),
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      showModalBottomsheet(context);
                      print(widget.uid);
                      print(audiocontroller.uid);
                    },
                    child: const Icon(
                      Icons.add,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future showModalBottomsheet(BuildContext contex) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 140,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.mic),
                title: const Text("Mikrofonu Aç"),
                onTap: () {
                  audiocontroller.intrdownloadMp3();
                },
              ),
              ListTile(
                leading: const Icon(Icons.music_note_rounded),
                title: const Text("Dosyalardan seç"),
                onTap: () {
                  audiocontroller.selectAndUploadMp3();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

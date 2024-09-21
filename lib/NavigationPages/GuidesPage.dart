import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_me/widgets/PlayerWidget.dart';

class AsistansPage extends StatelessWidget {
  const AsistansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Rehberlerimiz",
              style: GoogleFonts.inter(fontSize: 25),
            ),
          ),
          const PlayerWidget(
              img: "assets/profile/caner.png",
              name: "Caner",
              audio:
                  "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/mp3_files%2Fcaner%20free.mp3?alt=media&token=18925d5a-9fdd-4209-994f-01a29b53f982"),
          const PlayerWidget(
              img: "assets/profile/sila.png",
              name: "Sıla",
              audio:
                  "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/mp3_files%2Fsıla%20intro%20.mp3?alt=media&token=9ce5a258-f8cd-4da0-9766-830869bca0d9"),
          const PlayerWidget(
              img: "assets/profile/yusuf.png",
              name: "Yusuf",
              audio:
                  "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/mp3_files%2Fyusuf.mp3?alt=media&token=9bb4935f-74a3-4e1b-a5a5-14b786fce379"),
          const PlayerWidget(
              img: "assets/profile/ismet.png",
              name: "İsmet",
              audio:
                  "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/mp3_files%2Fismet%20free.mp3?alt=media&token=5ed4765c-687e-446f-84cf-64d5a9444854"),
        ],
      ),
    );
  }
}

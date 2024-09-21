import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_me/widgets/PlayerWidget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PlacesDetail extends StatelessWidget {
  const PlacesDetail({super.key});

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
                              onPressed: () => {Navigator.pop(context)},
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 35,
                                color: Colors.white,
                              ))),
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
            width: 100.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Side Antik Kent",
                    style: GoogleFonts.inter(
                        fontSize: 25, fontWeight: FontWeight.w200),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 19, horizontal: 10),
                  child: Container(
                      width: 90.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: const Image(
                          image: AssetImage('assets/images/side.png'),
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                const PlayerWidget(
                    img: "assets/profile/caner.png",
                    name: "Caner",
                    audio: "audio/side.mp3"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 80.w,
                    child: const Text(
                        "Side Antik Kenti, Antalya'nın Manavgat ilçesinde, Akdeniz kıyısında yer alan tarihi bir yerleşimdir. Milattan önce 7. yüzyılda Yunan kolonistler tarafından kurulan Side, Pamphylia bölgesinin önemli bir liman kenti olmuştur. Roma ve Bizans dönemlerinde büyük bir ticaret merkezi olarak gelişmiştir.Kentte bulunan Side Antik Tiyatrosu, Apollon Tapınağı, Athena Tapınağı ve Vespasianus Çeşmesi gibi yapılar, kentin zengin tarihini ve mimari güzelliklerini yansıtır. Özellikle Apollon Tapınağı, gün batımında sunduğu manzarayla ünlüdür. Günümüzde Side Antik Kenti, önemli bir turistik bölge olarak her yıl birçok ziyaretçiyi ağırlar. Arkeolojik kazılar ve restorasyon çalışmaları devam etmekte olup, kentteki eserler Side Arkeoloji Müzesi'nde sergilenmektedir. Side, tarih ve doğanın iç içe geçtiği, ziyaretçilere eşsiz bir deneyim sunan bir antik kenttir."),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

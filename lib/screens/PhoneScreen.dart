import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_me/NavigationPages/HomePage.dart';
import 'package:guide_me/screens/MainPage.dart';
import 'package:guide_me/widgets/Button.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _verificationId;
  bool isloading = false;
  bool isVisible = true;
  bool isCodeSent = false;
  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+90${_phoneController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Otomatik doğrulama tamamlandığında çağrılır
        await _auth.signInWithCredential(credential);
        print('Doğrulama otomatik olarak tamamlandı');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Doğrulama hatası: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        print('Doğrulama kodu gönderildi');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<bool> _verifyCode() async {
    String smsCode = _codeController.text.trim();

    if (_verificationId != null) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      try {
        await _auth.signInWithCredential(credential);
        final User? user = _auth.currentUser;
        final FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection('users').doc(user!.uid).set({
          'phone': user.phoneNumber,
          'uid': user.uid,
          'role': 'user',
        });
        print('Telefon doğrulama başarılı');
        return true;
      } catch (e) {
        print('Doğrulama hatası: $e');
        return false;
      }
    }

    return false; // Add this line to ensure a value is always returned
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 100.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.h,
                ),
                Visibility(
                    visible: isVisible,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Telefonla devam et",
                            style: GoogleFonts.inter(
                                fontSize: 23, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 0, 4),
                          child: Text(
                            "Bu numaraya bir doğrulama kodu göndereceğiz",
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 9, 0, 20),
                          child: Container(
                            width: 90.w,
                            height: 65,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/flags/tr.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "+90",
                                    style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 1,
                                    height: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 50.w,
                                    child: TextField(
                                      // undercore

                                      controller: _phoneController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        hintText: "Telefon Numarası",
                                        hintStyle: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: MainButton(
                              text: "Kod Gönder",
                              onPressed: () => {
                                    setState(() {
                                      isloading = true;
                                    }),
                                    _verifyPhoneNumber(),
                                    setState(() {
                                      isloading = false;
                                      isVisible = false;
                                      isCodeSent = true;
                                    }),
                                  },
                              isLoading: isloading),
                        )
                      ],
                    )),
                Visibility(
                    visible: isCodeSent,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Kodu Girin",
                            style: GoogleFonts.inter(
                                fontSize: 23, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 0, 4),
                          child: Text(
                            "${_phoneController.text} numarasına gönderilen kodu girin",
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 9, 0, 20),
                          child: Container(
                            width: 90.w,
                            height: 65,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 50.w,
                                    child: TextField(
                                      // undercore

                                      controller: _codeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        hintText: "Kod",
                                        hintStyle: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: MainButton(
                              text: "Kodu Onayla",
                              onPressed: () async => {
                                    setState(() {
                                      isloading = true;
                                    }),
                                    if (await _verifyCode())
                                      {Get.to(() => const Mainpage())}
                                    else
                                      {print("Doğrulama başarısız")},
                                    setState(() {
                                      isloading = false;
                                      isVisible = false;
                                    }),
                                  },
                              isLoading: isloading),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

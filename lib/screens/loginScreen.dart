import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_me/NavigationPages/HomePage.dart';
import 'package:guide_me/controller/showAlert.dart';
import 'package:guide_me/controller/user.dart';
import 'package:guide_me/screens/MainPage.dart';
import 'package:guide_me/screens/PhoneScreen.dart';
import 'package:guide_me/screens/signUpScreen.dart';
import 'package:guide_me/widgets/Button.dart';
import 'package:guide_me/widgets/Textwidget.dart';
import 'package:guide_me/widgets/flushBarAlert.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

final TextEditingController _emailcontroller = TextEditingController();
final TextEditingController _passwordcontroller = TextEditingController();
bool isloading = false;
final UserController userController = UserController();

class _LoginScreenState extends State<LoginScreen> {
  bool validateEmail(String email) {
    // Regular expression for email validation
    String pattern =
        r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dispose() {
      _emailcontroller.dispose();
      _passwordcontroller.dispose();
      super.dispose();
    }

    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundimage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 100.w,
                  height: 30.h,
                  child: Center(
                    child: Image.asset(
                      'assets/logo/logo.png',
                      width: 100.w,
                      height: 30.h,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 100.w,
                  child: Text(
                    textAlign: TextAlign.center,
                    'Hoşgeldiniz',
                    style: GoogleFonts.inter(
                        fontSize: 24, fontWeight: FontWeight.w200),
                  ),
                ),
                const SizedBox(height: 30),
                TextFieldWidget(
                    textEditingController: _emailcontroller,
                    obsoureText: false,
                    placeholder: "E-mail Adresinizi Girin",
                    hintText: "E-mail Adresi"),
                const SizedBox(height: 25),
                TextFieldWidget(
                    textEditingController: _passwordcontroller,
                    obsoureText: true,
                    placeholder: "Şifreniz",
                    hintText: "Şifre Girin"),
                const SizedBox(height: 20),
                MainButton(
                  isLoading: isloading,
                  text: "Giriş Yap",
                  onPressed: () {
                    setState(() {
                      isloading = true;
                    });
                    userController.login(_emailcontroller.text,
                        _passwordcontroller.text); // login fonksiyonu

                    setState(() {
                      isloading = false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Şununla devam et'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 15.w,
                      child: IconButton(
                        icon: Image.asset(
                            'assets/logo/google.png'), // Google icon
                        iconSize: 50,
                        onPressed: () async {
                          userController.googleSignIn();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    SizedBox(
                      width: 13.w,
                      child: IconButton(
                        icon: Image.asset(
                            'assets/logo/facebook.png'), // Google icon
                        iconSize: 50,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    SizedBox(
                      width: 13.w,
                      child: IconButton(
                        icon:
                            Image.asset('assets/logo/phone.png'), // Google icon
                        iconSize: 50,
                        onPressed: () {
                          Get.to(() => const PhoneScreen());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signupscreen()),
                      )
                    },
                    child: const Text(
                      'Hesabın yok mu? Kayıt Ol',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

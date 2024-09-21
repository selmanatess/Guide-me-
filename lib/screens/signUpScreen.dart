import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guide_me/controller/showAlert.dart';
import 'package:guide_me/controller/user.dart';
import 'package:guide_me/screens/loginScreen.dart';
import 'package:guide_me/widgets/Button.dart';
import 'package:guide_me/widgets/Textwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guide_me/widgets/flushBarAlert.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  _SignupscreenState createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isloading = false;
  final UserController userController = UserController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TextEditingController'ları ekranda kullanmadığınızda boşaltmayı unutmayın.
    _emailController.dispose();
    _passwordController.dispose();
    _namecontroller.dispose();
    _phonecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 45.w,
                child: Center(
                  child: Image.asset('assets/logo/logo.png'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 100.w,
                child: Text(
                  textAlign: TextAlign.center,
                  'Kayıt Ol',
                  style: GoogleFonts.inter(
                      fontSize: 24, fontWeight: FontWeight.w200),
                ),
              ),
              const SizedBox(height: 30),
              TextFieldWidget(
                textEditingController: _namecontroller,
                obsoureText: false,
                hintText: "Ad Soyad",
                placeholder: "Adınız ve Soyadınız",
              ),
              const SizedBox(height: 20),
              TextFieldWidget(
                textEditingController: _emailController,
                obsoureText: false,
                hintText: "E-mail Adresi",
                placeholder: "E-mail Adresinizi Girin",
              ),
              const SizedBox(height: 20),
              Container(
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
                            fontSize: 20, fontWeight: FontWeight.w400),
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          maxLength: 10,
                          style: GoogleFonts.inter(
                              fontSize: 23, fontWeight: FontWeight.w400),
                          controller: _phonecontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: "(5xx) xxx xx xx",
                            hintStyle: GoogleFonts.inter(
                                fontSize: 23, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFieldWidget(
                textEditingController: _passwordController,
                obsoureText: true,
                hintText: "Şifreniz",
                placeholder: "Güçlü bir şifre belirleyin",
              ),
              const SizedBox(height: 20),
              MainButton(
                isLoading: isloading,
                text: "Kayıt Olun",
                onPressed: () async {
                  setState(() {
                    isloading = true;
                  });

                  bool isRegistered = await userController.register(
                      _emailController.text,
                      _passwordController.text,
                      _namecontroller.text,
                      _phonecontroller.text);

                  if (isRegistered) {
                    //cleae all textfields
                    _emailController.clear();
                    _passwordController.clear();
                    _namecontroller.clear();
                    _phonecontroller.clear();
                  }

                  setState(() {
                    isloading = false;
                  });
                },
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Hesabın yok mu?  Giriş yap',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

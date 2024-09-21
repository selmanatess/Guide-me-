import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_me/screens/loginScreen.dart';
import 'package:guide_me/widgets/Button.dart';
import 'package:guide_me/widgets/Textwidget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controller/user.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  TextEditingController confirmEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController repasswordEditingController = TextEditingController();
  final UserController userController = Get.find<UserController>();
  bool isloading = false;
  @override
  void dispose() {
    confirmEditingController.dispose();
    passwordEditingController.dispose();
    repasswordEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Değiştir'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                    "Şifrenizi güvenli bir şekilde güncellemek için aşağıdaki alanları doldurunuz. Güçlü bir şifre oluşturun"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: 90.w,
                  child: TextFieldWidget(
                      placeholder: "Kullandığınız şifreyi girin",
                      hintText: "Mevcut Şifre",
                      obsoureText: true,
                      textEditingController: confirmEditingController),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: 90.w,
                  child: TextFieldWidget(
                      placeholder: "Yeni şifreyi girin",
                      hintText: "Yenı Şifre",
                      obsoureText: true,
                      textEditingController: passwordEditingController),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: 90.w,
                  child: TextFieldWidget(
                      placeholder: "Yeni şifreyi tekrar girin",
                      hintText: "Yeni Şifre Tekrar",
                      obsoureText: true,
                      textEditingController: repasswordEditingController),
                ),
              ),
              MainButton(
                  text: "Şifreyi Değiştir",
                  onPressed: () {
                    setState(() {
                      isloading = true;
                    });
                    userController.changePassword(
                        confirmEditingController.text,
                        passwordEditingController.text,
                        repasswordEditingController.text);
                    setState(() {
                      isloading = false;
                    });
                  },
                  isLoading: isloading),
            ],
          ),
        ),
      ),
    );
  }
}

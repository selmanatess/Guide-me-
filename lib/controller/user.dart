import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guide_me/controller/photo.dart';

import 'package:guide_me/controller/showAlert.dart';
import 'package:guide_me/screens/MainPage.dart';
import 'package:guide_me/screens/promotion.dart';

class UserController extends GetxController {
  //define name
  RxString name = "".obs;
  RxString email = "".obs;
  RxString password = "".obs;
  RxString phone = "".obs;
  RxString profilePic = "".obs;
  RxString role = "".obs;
  RxString uid = "".obs;
  RxString subscribe = "".obs;
  RxList dataList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredListe = <Map<String, dynamic>>[].obs;
  var created_at = DateTime.now().obs;

  var user = Rx<User?>(null);
  var isLoading = true.obs;
  void setName(String value) {
    name.value = value;
  }

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void setPhone(String value) {
    phone.value = value;
    FirebaseFirestore.instance.collection("users").doc(uid.value).update({
      "phone": value,
    });
  }

  void setProfilePic(String value) {
    profilePic.value = value;
  }

  setRole(String value) {
    role.value = value;
  }

  setUid(String value) {
    uid.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(user, handleAuthStateChanged);
    fetchUser();
  }

  void handleAuthStateChanged(User? user) {
    isLoading.value = false;
    if (user == null) {
      Get.offAll(() => const Promotion());
    } else {
      fetchUser();
    }
  }

  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  bool validateEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void changePassword(
      String confirmpassword, String password, String repassword) async {
    if (confirmpassword.isNotEmpty &&
        password.isNotEmpty &&
        repassword.isNotEmpty) {
      if (password == repassword) {
        if (password.length >= 6) {
          final User? user = _auth.currentUser;
          final credential = EmailAuthProvider.credential(
              email: user!.email!, password: confirmpassword);
          user.reauthenticateWithCredential(credential).then((value) {
            user.updatePassword(password).then((value) async {
              //delay flushbar
              await Future.delayed(const Duration(seconds: 2));
              final Showalert showAlert = Get.find<Showalert>();
              showAlert.showFlushbar(Get.context!, Icons.check, "Başarılı",
                  "Şifre değiştirme işlemi başarılı");
              Get.offAllNamed("/");
            }).catchError((onError) {
              final Showalert showAlert = Get.find<Showalert>();
              showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
                  "Şifre değiştirme işlemi başarısız, lütfen tekrar deneyin");
            });
          }).catchError((onError) {
            final Showalert showAlert = Get.find<Showalert>();
            showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
                "Şifre değiştirme işlemi başarısız, lütfen tekrar deneyin");
          });
        } else {
          final Showalert showAlert = Get.find<Showalert>();
          showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
              "Şifreniz en az 6 karakter olmalıdır");
        }
      } else {
        final Showalert showAlert = Get.find<Showalert>();
        showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
            "Girdiğiniz şifreler birbirleriyle uyuşmuyor");
      }
    } else {
      final Showalert showAlert = Get.find<Showalert>();
      showAlert.showFlushbar(
          Get.context!, Icons.error, "Hata", "Lütfen tüm alanları doldurunuz");
    }
  }

  Future<void> signOut() async {
    //showflushbar
    final Showalert showAlert = Get.find<Showalert>();
    showAlert.showFlushbar(Get.context!, Icons.check, "Başarılı",
        "Çıkış işlemi başarılı, yönlendiriliyorsunuz");
    //delay flushbar
    await Future.delayed(const Duration(seconds: 2));
    await _auth.signOut();

    Get.offAll(() => const Promotion());
  }

  Future<bool> register(
      String email, String name, String password, String phone) async {
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        name.isNotEmpty &&
        phone.isNotEmpty) {
      if (validateEmail(email)) {
        try {
          UserCredential userCredential = await _auth
              .createUserWithEmailAndPassword(email: email, password: password);

          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
            "name": name,
            "email": email,
            "created_at": DateTime.now(),
            "phone": phone,
            "uid": userCredential.user!.uid,
            "role": "user",
            "profilePic":
                "https://firebasestorage.googleapis.com/v0/b/guide-me-681d7.appspot.com/o/default%2Fdefault_profile.png?alt=media&token=c8abeed5-7827-42c8-9f1d-e46e2fb4e277",
            "subscribe": "Free",
          });

          final Showalert showAlert = Get.find<Showalert>();
          showAlert.showFlushbar(Get.context!, Icons.check, "Başarılı",
              "Kayıt işlemi başarılı, lütfen giriş yapınız");
          Get.offAllNamed("/login");
          return true;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            final Showalert showAlert = Get.find<Showalert>();
            showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
                "Şifre zayıf, lütfen daha güçlü bir şifre giriniz");
          } else if (e.code == 'email-already-in-use') {
            final Showalert showAlert = Get.find<Showalert>();
            showAlert.showFlushbar(
                Get.context!, Icons.error, "Hata", "Bu email zaten kullanımda");
          }
        } catch (e) {
          final Showalert showAlert = Get.find<Showalert>();
          showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
              "Kayıt sırasında bir hata oluştu.");
          return false;
        }
      } else {
        final Showalert showAlert = Get.find<Showalert>();
        showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
            "Geçerli bir email adresi giriniz");
        return false;
      }
    } else {
      final Showalert showAlert = Get.find<Showalert>();
      showAlert.showFlushbar(
          Get.context!, Icons.error, "Hata", "Lütfen tüm alanları doldurunuz");
      return false;
    }
    return false; // Add this line to ensure a value is always returned.
  }

  Future<void> login(String email, String password) async {
    User? user;

    if (validateEmail(email)) {
      if (email.isNotEmpty && password.isNotEmpty) {
        try {
          UserCredential userCredential = await _auth
              .signInWithEmailAndPassword(email: email, password: password);

          user = userCredential.user;
          if (user != null) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .update({"lastLogin": DateTime.now()});

            fetchUser();
            final PhotoController photoController = Get.find<PhotoController>();
            photoController.fetchPhoto();
          }

          // Get.find() ile final Showalert showAlert=Get.find<Showalert>();
          //Showalert controller'ına erişin

          final Showalert showAlert = Get.find<Showalert>();
          showAlert.showFlushbar(Get.context!, Icons.check, "Başarılı",
              "Giriş işlemi başarılı, yönlendiriliyorsunuz");

          //delay flushbar
          await Future.delayed(const Duration(seconds: 2));
          Get.offAllNamed("/");
        } on FirebaseAuthException catch (e) {
          print("Hata: ${e.code}");
          if (e.code == 'invalid-credential') {
            final Showalert showAlert = Get.find<Showalert>();
            showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
                "Geçersiz kimlik bilgileri, lütfen tekrar deneyin");
          }
          if (e.code == 'user-not-found') {
            final Showalert showAlert = Get.find<Showalert>();
            showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
                "Kullanıcı bulunamadı, lütfen kayıt olun");
          } else if (e.code == 'wrong-password') {
            final Showalert showAlert = Get.find<Showalert>();
            showAlert.showFlushbar(Get.context!, Icons.error, "Hatalı Şifre",
                "Girdiğiniz şifre hatalı");
          }
        }
      } else {
        final Showalert showAlert = Get.find<Showalert>();
        showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
            "Lütfen tüm alanları doldurunuz");
      }
    } else {
      final Showalert showAlert = Get.find<Showalert>();
      showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
          "Geçerli bir email adresi giriniz");
    }
  }

  void fetchUser() {
    final User? user = _auth.currentUser;
    if (user != null) {
      db.collection("users").doc(user.uid).get().then((value) {
        print("value: ${value.data()}");
        name.value = value.data()!["name"];
        email.value = value.data()!["email"];
        phone.value = value.data()?["phone"] ?? "Yok";
        profilePic.value = value.data()!["profilePic"];
        role.value = value.data()!["role"];
        uid.value = value.data()!["uid"];
        subscribe.value = value.data()!["subscribe"];
      });
    }
  }

  void getinfo() {
    print("name: ${name.value}");
    print("email: ${email.value}");
    print("phone: ${phone.value}");
    print("profilePic: ${profilePic.value}");
    print("role: ${role.value}");
    print("uid: ${uid.value}");
  }

  Future<void> googleSignIn() async {
    User? user;
    try {
      // Kullanıcının Google hesabını seçmesini sağlar
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Eğer kullanıcı bir hesap seçmediyse (örneğin geri tuşuna bastıysa)
      if (googleUser == null) {
        final Showalert showAlert = Get.find<Showalert>();
        showAlert.showFlushbar(
            Get.context!, Icons.error, "Hata", "Kullanıcı bir hesap seçmedi");
        return; // İşlem tamamlandı, çıkış yap
      }

      // Google hesap kimlik doğrulama bilgilerini alır
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Google kimlik bilgileri ile Firebase kimlik doğrulama sağlar
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase'de oturum açmayı dener
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      user = userCredential.user;
      if (user != null) {
        final userDoc = await db.collection("users").doc(user.uid).get();

        if (userDoc.exists) {
          // Firestore'da kullanıcı varsa
          final data = userDoc.data() as Map<String, dynamic>;
          final profilePic = data['profilePic'] as String?;

          if (profilePic != null && profilePic.isNotEmpty) {
            // Firestore'dan alınan profil resmini kullan
            await db.collection("users").doc(user.uid).update({
              "lastLogin": DateTime.now(),
            });
          } else {
            // Firestore'da profil resmi yoksa, kullanıcı fotoğrafını kullan
            await db.collection("users").doc(user.uid).update({
              "profilePic": user.photoURL,
              "lastLogin": DateTime.now(),
            });
          }
        } else {
          // Firestore'da kullanıcı yoksa, yeni kullanıcı oluşturur
          await db.collection("users").doc(user.uid).set({
            "email": user.email,
            "uid": user.uid,
            "name": user.displayName,
            "profilePic": user.photoURL,
            "phone": user.phoneNumber,
            "role": "user",
            "subscribe": "Free",
            "lastLogin": DateTime.now(),
            "created_at": DateTime.now(),
          });
        }

        // Kullanıcı bilgilerini al
        fetchUser();
        PhotoController photoController =
            Get.put<PhotoController>(PhotoController());
        photoController.fetchPhoto();
        // Flushbar göster
        final Showalert showAlert = Get.find<Showalert>();
        await Future.delayed(const Duration(seconds: 2));
        showAlert.showFlushbar(Get.context!, Icons.check, "Başarılı",
            "Oturum açma başarılı, yönlendiriliyorsunuz");

        // Ana sayfaya yönlendir
        Get.offAllNamed("/");
      }
    } catch (e) {
      // Hata durumunda flushbar göster
      print("google giri$e");
      final Showalert showAlert = Get.find<Showalert>();
      showAlert.showFlushbar(
          Get.context!, Icons.error, "Hata", "Oturum açma başarısız");
    }
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      dataList.value = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print(dataList);
    } catch (e) {
      print("Hata: $e");
    }
  }

  void deleteAccount(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      final Showalert showAlert = Get.find<Showalert>();
      //delete user

      showAlert.showFlushbar(
          Get.context!, Icons.check, "Başarılı", "Hesabınız başarıyla silindi");
      fetchData();
      filteredListe.value = dataList.toList() as List<Map<String, dynamic>>;
    } catch (e) {
      print("Hata: $e");
    }
  }

  void changeRole(String uid, String role) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        "role": role,
      });
      final Showalert showAlert = Get.find<Showalert>();
      //delete user

      showAlert.showFlushbar(Get.context!, Icons.check, "Başarılı",
          "Kullanıcının rolü başarıyla değiştirildi");
      fetchData();
      filteredListe.value = dataList.toList() as List<Map<String, dynamic>>;
    } catch (e) {
      print("Hata: $e");
    }
  }

  void changeSubscribe(String uid, String subscribe) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        "subscribe": subscribe,
      });
      final Showalert showAlert = Get.find<Showalert>();
      //delete user

      showAlert.showFlushbar(Get.context!, Icons.check, "Başarılı",
          "Kullanıcının abonelik durumu başarıyla değiştirildi");
      fetchData();
      filteredListe.value = dataList.toList() as List<Map<String, dynamic>>;
    } catch (e) {
      print("Hata: $e");
    }
  }
}

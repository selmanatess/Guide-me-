import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_me/controller/showAlert.dart';
import 'package:guide_me/controller/user.dart';
import 'package:permission_handler/permission_handler.dart';

class Audiocontroller extends GetxController {
  FirebaseStorage storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  RxString uid = ''.obs;
  RxMap place = {}.obs;
  RxList intro = [].obs;

  setUid(String id) {
    uid.value = id;
  }

  Future<void> intrdownloadMp3() async {
    try {
      intro.clear();
      DocumentSnapshot documentSnapshot =
          await db.collection('places').doc(uid.value).get();
      print("UID: ${uid.value}");
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        intro.clear();
        for (var i = 0; i < data['intro'].length; i++) {
          intro.add(data['intro'][i]);
        }

        print('Kullanıcı verisi: ${intro}');
      } else {
        print('Belge bulunamadı.');
      }
    } catch (e) {
      print('Veritabanı hatası: $e');
    }
  }

  Future<void> selectAndUploadMp3() async {
    // İzin isteme
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Depolama izni verilmedi');
      return;
    }

    // .mp3 dosyası seçme
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      String? filePath = result.files.single.path;

      if (filePath != null) {
        try {
          // Firebase Storage yolunu belirleme
          String fileName = result.files.single.name;
          Reference storageRef = storage.ref().child('mp3_files/$fileName');

          // Dosyayı Firebase'e yükleme
          await storageRef.putFile(File(filePath));

          // Yükleme başarılı olursa
          String downloadURL = await storageRef.getDownloadURL();
          print('Dosya Firebase\'e yüklendi. URL: $downloadURL');

          // Kullanıcı bilgilerini getir
          UserController userController = Get.find<UserController>();
          userController.fetchUser();
          String name = userController.name.value.split(' ')[0];
          String picUrl = userController.profilePic.value;

          // Firestore'da 'places' koleksiyonundaki ilgili dökümana update işlemi
          Map<String, dynamic> newIntro = {
            'audio': downloadURL,
            'name': name,
            'picUrl': picUrl,
          };
          print("UID: ${uid.value}");
          db.collection('places').doc(uid.value).update({
            'intro': FieldValue.arrayUnion([newIntro])
          }).then((_) {
            Showalert().showFlushbar(Get.context!, Icons.check, "Başarılı",
                "Ses dosyası başarıyla yüklendi");
          }).catchError((error) {
            print('Veritabanı güncelleme hatası: $error');
          });
        } catch (e) {
          print('Yükleme hatası: $e');
        }
      }
    } else {
      print('Dosya seçilmedi.');
    }
  }
}

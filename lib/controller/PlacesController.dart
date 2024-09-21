import 'dart:io';

import 'package:another_flushbar/flushbar_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guide_me/controller/showAlert.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class Placescontroller extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString placeName = ''.obs;
  RxString placeDescription = ''.obs;
  RxString placespecies = ''.obs;
  RxString imageUrl = ''.obs;
  RxString filePath = ''.obs;

  //placeposition
  Rx<LatLng> placeposition = Rx<LatLng>(const LatLng(0.0, 0.0));
  Map<String, dynamic> place = {};
  var places = [].obs;

  void setPlaceName(String name) {
    placeName.value = name;
  }

  setPlaceDescription(String description) {
    placeDescription.value = description;
  }

  setPlaceSpecies(String species) {
    placespecies.value = species;
  }

  setPlacePosition(LatLng position) {
    placeposition.value = position;
  }

  setFilePath(String path) {
    filePath.value = path;
  }

  setimageUrl(String url) {
    imageUrl.value = url;
  }

  setPlaces(Map<String, dynamic> value) {
    place = value;
  }

  void clear() {
    placeName.value = '';
    placeDescription.value = '';
    placespecies.value = '';
    placeposition.value = const LatLng(0.0, 0.0);
  }

  @override
  void onInit() {
    clear();
    getPlace();
    super.onInit();
  }
  // get place to firebase

  void getPlace() async {
    try {
      places.value = [];
      await FirebaseFirestore.instance.collection('places').get().then((value) {
        for (var element in value.docs) {
          place = element.data();
          places.add(place);
        }
      });
    } catch (e) {
      Showalert alert = Get.find<Showalert>();
      alert.showFlushbar(Get.context!, Icons.error, "Hata",
          "Yerler getirilirken bir hata oluştu");
    }
  }

  void getinfo() {
    print("Place: $place");
    print("PlaceName: $placeName");
    print("PlaceDescription: $placeDescription");
    print("PlaceSpecies: $placespecies");
    print("PlacePosition: $placeposition");
  }

  void savePlace() async {
    if (placeName.value.isNotEmpty &&
        placeDescription.value.isNotEmpty &&
        placespecies.value.isNotEmpty &&
        placeposition.value.latitude != 0.0 &&
        imageUrl.value.isNotEmpty) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('places').doc();
      try {
        await docRef.set({
          'uid': docRef.id,
          'placeName': placeName.value,
          'placeDescription': placeDescription.value,
          'placespecies': placespecies.value,
          'position': {
            placeposition.value.latitude,
            placeposition.value.longitude
          },
          'imageUrl': imageUrl.value,
        }, SetOptions(merge: true));
        clear();
        Showalert alert = Get.find<Showalert>();
        alert.showFlushbar(
            Get.context!, Icons.check, "Başarılı", "Yer başarıyla kaydedildi");
      } catch (e) {
        print(e);
        Showalert alert = Get.find<Showalert>();
        alert.showFlushbar(Get.context!, Icons.error, "Hata",
            "Yer kaydedilirken bir hata oluştu");
      }
    }
  }

  Future<void> requestCameraPermission(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      _pickImageFromCamera();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      _showPermissionDeniedDialog(context);
    }
  }

  Future<void> requestGalleryPermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      _pickImageFromGallery();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      _showPermissionGalleryDeniedDialog(context);
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("İzin Gerekli"),
        content: const Text("Kamera izni olmadan fotoğraf çekemezsiniz."),
        actions: [
          TextButton(
            child: const Text("Tamam"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final file = File(filePath.value);

      // Eski dosyayı sil
      if (await file.exists()) {
        await file.delete();
        setFilePath(''); // Dosya yolunu sıfırla
      }

      // Dosyayı benzersiz bir isimle kaydet
      final directory = await path_provider.getApplicationDocumentsDirectory();
      final String newFileName =
          'profile_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final String newFilePath = path.join(directory.path, newFileName);

      final File savedImage = File(newFilePath);
      await savedImage.writeAsBytes(await pickedImage.readAsBytes());

      setFilePath(newFilePath); // Yeni dosya yolunu kaydet
      _uploadImageToFirebase();
      print("Yeni resim kaydedildi: $newFilePath");
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(filePath.value);

      // Eski dosyayı sil
      if (await file.exists()) {
        await file.delete();
        setFilePath(''); // Dosya yolunu sıfırla
      }

      // Dosyayı benzersiz bir isimle kaydet
      final directory = await path_provider.getApplicationDocumentsDirectory();
      final String newFileName =
          'profile_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final String newFilePath = path.join(directory.path, newFileName);

      final File savedImage = File(newFilePath);
      await savedImage.writeAsBytes(await pickedImage.readAsBytes());

      setFilePath(newFilePath); // Yeni dosya yolunu kaydet
      await _uploadImageToFirebase();
      print("Yeni resim kaydedildi: $newFilePath");
    }
  }

  void _showPermissionGalleryDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("İzin Gerekli"),
        content:
            const Text("Galeriden fotoğraf seçmek için izniniz gerekiyor."),
        actions: [
          TextButton(
            child: const Text("Tamam"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _uploadImageToFirebase() async {
    try {
      // Kullanıcı UID'si

      // Dosya adı ve Firebase Storage referansı
      final fileName = path.basename(filePath.value);
      final storageRef =
          FirebaseStorage.instance.ref().child('placePics//$fileName');

      // Dosyayı Firebase Storage'a yükle
      final TaskSnapshot snapshot =
          await storageRef.putFile(File(filePath.value));

      // Yükleme tamamlandığında, URL'yi al
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Firestore'a URL'yi kaydet
      setimageUrl(downloadUrl);

      // Flushbar ile başarı mesajı göster
      final Showalert showAlert = Get.find<Showalert>();
      showAlert.showFlushbar(
          Get.context!, Icons.check, "Başarılı", "Fotoğraf başarıyla yüklendi");
    } catch (e) {
      // Flushbar ile hata mesajı göster
      final Showalert showAlert = Get.find<Showalert>();
      showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
          "Fotoğraf yüklenirken hata Oluştu: ${e.toString()}");
      print(e);
    }
  }
}

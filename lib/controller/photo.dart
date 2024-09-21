import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_me/controller/showAlert.dart';
import 'package:guide_me/controller/user.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart'; // Import the correct package

class PhotoController extends GetxController {
  final RxString filepath = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  setFilePath(String path) {
    filepath.value = path;
  }

  @override
  void onInit() {
    fetchPhoto(); // Başlangıçta resmi indir
    super.onInit();
  }

  Future<void> fetchPhoto() async {
    final UserController userController = Get.find<UserController>();
    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        final DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final profilePicUrl = data['profilePic'] as String?;

          if (profilePicUrl != null) {
            // Resmin URL'sini al
            final http.Response response =
                await http.get(Uri.parse(profilePicUrl));
            final file = File(filepath.value);

            if (response.statusCode == 200) {
              if (await file.exists()) {
                await file.delete(); // Eski dosyayı sil
                setFilePath(''); // Dosya yolunu sıfırla
              }

              // Dosyayı benzersiz bir isimle kaydet
              final directory =
                  await path_provider.getApplicationDocumentsDirectory();
              final String newFileName =
                  'profile_image_${DateTime.now().millisecondsSinceEpoch}.png';
              final String newFilePath = path.join(directory.path, newFileName);

              final File savedImage = File(newFilePath);
              await savedImage.writeAsBytes(response.bodyBytes);

              setFilePath(newFilePath); // Yeni dosya yolunu kaydet

              print("Yeni resim kaydedildi: $newFilePath");
            } else {
              print(
                  "Resmi indirme sırasında bir hata oluştu: ${response.statusCode}");
            }
          }
        }
      } catch (e) {
        print("Hata: $e");
      }
    }
  }

  void deletePathphoto() async {
    final User? user = _auth.currentUser;
    final file = File(filepath.value);

    if (await file.exists()) {
      print("Dosya var");
      await file.delete();
      setFilePath('');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'profilePic':
            "https://firebasestorage.googleapis.com/v0/b/guide-me-605ef.appspot.com/o/profilePics%2F123.png?alt=media&token=17d37d50-45c4-4a76-8692-8c4785f65de3",
      });
    } else {
      setFilePath('');
      print(filepath.value);
      print("Dosya yok");
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

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final file = File(filepath.value);

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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }

  Future<void> _uploadImageToFirebase() async {
    try {
      // Kullanıcı UID'si
      final User? user = _auth.currentUser;
      if (user == null) {
        print("Kullanıcı yok");
        return;
      } else {
        print("Kullanıcı var");
      }

      // Dosya adı ve Firebase Storage referansı
      final fileName = path.basename(filepath.value);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profilePics/${user.uid}/$fileName');

      // Dosyayı Firebase Storage'a yükle
      final TaskSnapshot snapshot =
          await storageRef.putFile(File(filepath.value));

      // Yükleme tamamlandığında, URL'yi al
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Firestore'a URL'yi kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'profilePic': downloadUrl,
      });

      // Flushbar ile başarı mesajı göster
      final Showalert showAlert = Get.find<Showalert>();
      showAlert.showFlushbar(Get.context!, Icons.check, "Başarılı",
          "Profil resmi başarıyla güncellendi");
    } catch (e) {
      // Flushbar ile hata mesajı göster
      final Showalert showAlert = Get.find<Showalert>();
      showAlert.showFlushbar(Get.context!, Icons.error, "Hata",
          "Profil resmi güncellenirken bir hata oluştu: ${e.toString()}");
      print(e);
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

  Future<void> requestGalleryPermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      _pickImageFromGallery();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      _showPermissionGalleryDeniedDialog(context);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(filepath.value);

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
}

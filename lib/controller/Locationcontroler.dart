import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Locationcontroler extends GetxController {
  var currentposition = Position(
    latitude: 0,
    longitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  ).obs;

  var selectedposition = Position(
    latitude: 0,
    longitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  ).obs;
  @override
  void onInit() {
    getCurrentLocation();
    super.onInit();
  }

  void setSelectedPosition(Position position) {
    selectedposition.value = position;
    print("Seçilen konum: ${selectedposition.value}");
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum hizmetlerinin etkin olup olmadığını kontrol edin
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Eğer değilse, kullanıcıya konum hizmetlerini açmasını söyleyin
      print('Konum hizmetleri devre dışı');
    }

    // Konum izni kontrolü yapın
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // İzin reddedildi
        print('Konum izni reddedildi');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Kullanıcı izni kalıcı olarak reddetti
      print('Konum izni kalıcı olarak reddedildi');
    }

    // Konum hizmetleri etkinse ve izinler verildiyse, konumu alabilirsiniz
    print(
        "Şu anki konum alınıyor${await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)}");
    currentposition.value = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

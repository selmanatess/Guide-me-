//auth services
import 'package:firebase_auth/firebase_auth.dart';

class Authservices {
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();
}

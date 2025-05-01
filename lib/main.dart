import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parcking_slot_booking/features/App/bindings/auth-binding.dart';
import 'package:parcking_slot_booking/features/Auth/pages/auth_pages.dart';
import 'package:parcking_slot_booking/features/Auth/pages/signIn_page.dart';
import 'package:parcking_slot_booking/features/parcking/bindings/parking_binding.dart';
import 'package:parcking_slot_booking/features/parcking/pages/parking_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signin', page: () => SignInPage()),
        GetPage(name: '/signup', page: () => SignUpPage()),
        GetPage(name: '/parking', page: () => ParkingPage(), binding: ParkingBinding()),
      ],
    );
  }
}

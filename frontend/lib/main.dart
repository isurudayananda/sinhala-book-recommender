import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:login_signup/screens/LoginPage.dart';
import 'package:login_signup/screens/SignupPage.dart';

void main() {
  var devicePre = true;

  if (devicePre) {
    runApp(DevicePreview(
      builder: (context) => const MyApp(),
    ));
  // ignore: dead_code
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sinhala Book Recommendation App',
      home: LoginPage(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:login_signup/screens/LoginPage.dart'; // Import LoginPage
import 'package:login_signup/screens/SignupPage.dart'; // Import SignupPage
import 'package:login_signup/screens/HomePage.dart'; // Import HomePage

void main() {
  var devicePre = true; // Set this to false when you no longer need device preview

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
    return MaterialApp(
      useInheritedMediaQuery: true, // Required for DevicePreview
      debugShowCheckedModeBanner: false,
      title: 'Sinhala Book Recommendation App',
      // Directly start the app with HomePage to see its output
      home: HomePage(
        preferences: ['Senkottan', 'Madol Duwa'], // Provide sample preferences for testing
      ),
      routes: {
        '/login': (context) => const LoginPage(), // LoginPage route
        '/signup': (context) => const SignupPage(), // SignupPage route
        '/home': (context) => HomePage(preferences: ['Senkottan', 'Madol Duwa']), // HomePage route
      },
      builder: DevicePreview.appBuilder, // Enables DevicePreview for responsiveness
    );
  }
}

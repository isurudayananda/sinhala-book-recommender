import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:login_signup/screens/LoginPage.dart'; 
import 'package:login_signup/screens/SignupPage.dart';
import 'package:login_signup/screens/HomePage.dart'; 
import 'package:provider/provider.dart';

class AuthState with ChangeNotifier {
  String? _token;

  String? get token => _token;

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }
}

void main() {
  bool devicePre = true; // Set this to true to enable DevicePreview

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: devicePre
          ? DevicePreview(
              enabled: true,
              builder: (context) => const MyApp(),
            )
          : const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true, // Required for DevicePreview
      debugShowCheckedModeBanner: false,
      title: 'Sinhala Book Recommendation App',
      // Start the app at the login page
      home: const LoginPage(), // Set LoginPage as the initial screen
      routes: {
        '/login': (context) => const LoginPage(), // LoginPage route
        '/signup': (context) => const SignupPage(), // SignupPage route
        '/home': (context) => HomePage(preferences: ['Senkottan', 'Madol Duwa']), // HomePage route with sample preferences
      },
      builder: DevicePreview.appBuilder, // Enables DevicePreview for responsiveness
    );
  }
}

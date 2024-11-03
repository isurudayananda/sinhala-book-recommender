import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:login_signup/main.dart';
import 'package:login_signup/screens/HomePage.dart';
import 'package:login_signup/screens/Signuppage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final username = _usernameController.text;
            final password = _passwordController.text;

            try {
              final response = await http.post(
                Uri.parse('http://localhost:8000/api/auth/login'),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: jsonEncode({
                  'username': username,
                  'password': password,
                }),
              );

              if (response.statusCode == 200) {
                final jsonResponse = jsonDecode(response.body);
                final accessToken = jsonResponse['access_token'];
                context.read<AuthState>().token = accessToken;

                // Navigate to the HomePage if the login is successful
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage(preferences: ['Senkottan', 'Madol Duwa'])),
                );
              } else {
                // Show an error message if the login fails
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid credentials'),
                  ),
                );
              }
            } catch (e) {
              // Show an error message if there's an error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 10, 10, 10).withOpacity(0.1),
            foregroundColor: const Color.fromARGB(255, 47, 3, 245),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text("Forgot password?",
          style: TextStyle(color: Color.fromARGB(255, 47, 3, 245))),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignupPage()));
            },
            child: const Text("Sign Up",
                style: TextStyle(color: Color.fromARGB(255, 47, 3, 245))))
      ],
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart'; // Import the HomePage widget

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int pageIndex = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedGender;
  int? _age;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final List<String> _categories = [
    'Translations', 'Novels', 'Biographies', 'Adventure', 'Child',
    'Fiction', 'Historical', 'Short stories', 'Sci-Fi', 'Spy',
    'Crime', 'Mystery', 'Educational'
  ];

  List<String> _selectedCategories = [];

  Future<void> _registerUser() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'http://localhost:8000/api/auth/register',
        data: {
          'username': _usernameController.text,
          'password': _passwordController.text,
          'email': _emailController.text,
          'gender': _selectedGender,
          'age': _age,
          'interested_categories': _selectedCategories.join(', '),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(preferences: _selectedCategories),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Create your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      IndexedStack(
                        index: pageIndex,
                        children: [
                          // Step 1: User Info
                          Column(
                            children: [
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.purple.withOpacity(0.1),
                                  filled: true,
                                  prefixIcon: const Icon(Icons.person),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.purple.withOpacity(0.1),
                                  filled: true,
                                  prefixIcon: const Icon(Icons.email),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.purple.withOpacity(0.1),
                                  filled: true,
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.purple.withOpacity(0.1),
                                  filled: true,
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword = !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscureConfirmPassword,
                              ),
                            ],
                          ),

                          // Step 2: Gender and Age
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text("Male"),
                                      value: "Male",
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text("Female"),
                                      value: "Female",
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: "Enter Age",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.purple.withOpacity(0.1),
                                  filled: true,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _age = int.tryParse(value);
                                  });
                                },
                              ),
                            ],
                          ),

                          // Step 3: Categories and Submit
                          Column(
                            children: [
                              const Text(
                                "Select Categories",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 100,
                                child: Wrap(
                                  spacing: 8.0,
                                  children: _categories.map((String category) {
                                    return ChoiceChip(
                                      label: Text(category),
                                      selected: _selectedCategories.contains(category),
                                      selectedColor: Colors.purple.withOpacity(0.4),
                                      onSelected: (bool selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedCategories.add(category);
                                          } else {
                                            _selectedCategories.remove(category);
                                          }
                                        });
                                      },
                                      backgroundColor: Colors.purple.withOpacity(0.1),
                                      labelStyle: TextStyle(
                                        color: _selectedCategories.contains(category)
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (pageIndex < 2) {
                                setState(() {
                                  pageIndex += 1;
                                });
                              } else {
                                _registerUser();
                              }
                            },
                            child: Text(pageIndex < 2 ? " Next " : " Sign Up "),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                              backgroundColor: const Color.fromARGB(255, 10, 10, 10).withOpacity(0.1),
                              foregroundColor: const Color.fromARGB(255, 47, 3, 245),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

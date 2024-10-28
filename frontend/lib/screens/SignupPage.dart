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
  String? _selectedAgeRange;

  final List<String> _categories = [
    'Translations', 'Novels', 'Biographies', 'Adventure', 'Child',
    'Fiction', 'Historical', 'Short stories', 'Sci-Fi', 'Spy',
    'Crime', 'Mystery', 'Educational'
  ];

  List<String> _selectedCategories = [];
  final List<String> _ageRanges = ['18-24', '25-34', '35-44', '45-54', '55+'];

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
                              DropdownButtonFormField<String>(
                                value: _selectedAgeRange,
                                decoration: InputDecoration(
                                  hintText: "Select Age Range",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.purple.withOpacity(0.1),
                                  filled: true,
                                ),
                                items: _ageRanges.map((String ageRange) {
                                  return DropdownMenuItem<String>(
                                    value: ageRange,
                                    child: Text(ageRange),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAgeRange = value;
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

                      const SizedBox(height: 20), // Add some space before the buttons

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
                                // Pass the selected categories to HomePage on signing up
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(preferences: _selectedCategories),
                                  ),
                                );
                              }
                            },
                            child: Text(pageIndex < 2 ? "Next >" : "Sign Up"),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                              backgroundColor: Colors.purple,
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

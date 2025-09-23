import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project/constants/colors.dart';
import 'package:mini_project/login.dart';

class signin extends StatefulWidget {
  const signin({super.key});
  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confrirmcontroller = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    _confrirmcontroller.dispose();
    super.dispose();
  }

  Future<bool> signUpUser(String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/auth/signup'); // Change if needed

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      print('Signup successful for $email');
      return true;
    } else {
      print('Signup failed: ${response.body}');
      return false;
    }
  }

  void _validationLogin() async {
    print("Login pressed!");
    final u = _userController.text.trim();
    final p = _passwordController.text;
    final cp = _confrirmcontroller.text;
    if (u.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both username and password')),
      );
      return;
    }
    if (p != cp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect password')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    bool success = await signUpUser(u, p);

    if (success) {
      try {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } catch (e) {
        print("Navigation Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Navigation failed: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Text(
            "Create an",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 45),
            textAlign: TextAlign.left,
          ),
          Text(
            "Account",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 45),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _userController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outlined),
              labelText: 'Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          SizedBox(height: 30),
          TextField(
            controller: _confrirmcontroller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              labelText: 'confirm password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _validationLogin,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Text(
                      'Create An Account',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

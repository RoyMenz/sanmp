import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project/constants/colors.dart';
import 'package:mini_project/forgot.dart';
import 'package:mini_project/littlecrochet.dart';
import 'package:mini_project/signin.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/auth/login'); // Change if needed

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Access Token: ${data["access_token"]}');
      // TODO: Store token securely if needed
      return true;
    } else {
      print('Login failed: ${response.body}');
      return false;
    }
  }

  void _validationLogin() async {
    print("Login pressed!");
    final u = _userController.text.trim();
    final p = _passwordController.text;
    if (u.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both username and password')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    bool success = await loginUser(u, p);

    if (success) {
      print("Credentials correct, navigating...");
      try {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Littlecrochet()),
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
      backgroundColor: Appcolors.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Text(
            "Welcome",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 45),
            textAlign: TextAlign.left,
          ),
          Text(
            "Back!",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 45),
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
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const forgot(),
                  ),
                );
              },
              child: Text(
                "Forgot Password?",
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
              ),
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
                      'Log in',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create an Account."),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const signin(),
                    ),
                  );
                },
                child: Text(
                  "Signin.",
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

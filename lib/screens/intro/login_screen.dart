import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:findovio/utilities/authentication/auth.dart';

import '../../routes/app_pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final keyboardHeight = WidgetsBinding.instance.window.viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    if (_isKeyboardVisible != isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isKeyboardVisible;
      });
    }
  }

  // Use this form key to validate user's input
  final _formKey = GlobalKey<FormState>();

  // Use this to store user inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double topMargin = _isKeyboardVisible ? 50.0 : 150.0;
    final double heightWithKeyboard = _isKeyboardVisible ? 5.0 : 25.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, topMargin, 25, 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Hello Again!',
                style: GoogleFonts.anybody(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Welcome back, we \nmissed you!',
                style: GoogleFonts.anybody(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 73, 73, 73),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wprowadź swój email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    contentPadding: EdgeInsets.all(16.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wprowadź hasło';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.all(16.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot password?',
                  style: GoogleFonts.anybody(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 58.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    var res = await Auth.signInWithEmailAndPassword(
                        _emailController.value.text,
                        _passwordController.value.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:
                            res == null ? Colors.green : Colors.red,
                        content: res == null
                            ? const Text("Logged In Successfully!")
                            : const Text("Wrong Email/Password!"),
                      ),
                    );
                    if (res == null) Get.offNamed(Routes.HOME);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.anybody(
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!_isKeyboardVisible) // Show the "Or continue with" lines, Facebook, and Google buttons only when the keyboard is not visible
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Color.fromARGB(255, 73, 73, 73),
                                  thickness: 1.0,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Or continue with',
                                  style: GoogleFonts.anybody(
                                    fontSize: 16,
                                    color:
                                        const Color.fromARGB(255, 73, 73, 73),
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Color.fromARGB(255, 73, 73, 73),
                                  thickness: 1.0,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: heightWithKeyboard),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 58.0,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    MdiIcons.facebook,
                                    color: Colors.white,
                                  ),
                                  label: const Text('Facebook',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: SizedBox(
                                height: 58.0,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    MdiIcons.google,
                                    color: Colors.black,
                                  ),
                                  label: Text('Google',
                                      style: GoogleFonts.anybody(
                                        color: Colors.black,
                                      )),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heightWithKeyboard),
                        if (!_isKeyboardVisible)
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 73, 73, 73)),
                              children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: "Sign up",
                                  style: GoogleFonts.anybody(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
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

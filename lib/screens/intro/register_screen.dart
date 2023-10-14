import 'dart:async';

import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/globals/user_data_global.dart';
import 'package:findovio/models/firebase_py_register_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:findovio/utilities/authentication/auth.dart';
import 'package:provider/provider.dart';

import '../../routes/app_pages.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  bool _isFirstTimePressed = false;
  User? user;
  String? res;
  String? resPy;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isFirstTimePressed = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isFirstTimePressed = true;
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

  int countSpecialCharacters(String input, bool countDigits) {
    RegExp digitRegex = RegExp(r'\d');
    RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    Iterable<RegExpMatch> matches;

    if (countDigits) {
      matches = digitRegex.allMatches(input);
    } else {
      matches = specialCharRegex.allMatches(input);
    }

    return matches.length;
  }

  void isPasswordValid() {
    RegExp passwordRegex = RegExp(r'^(?=.*?[0-9])(?=.*?[^\w\s]).{8,}$');
    String password = _passwordController.value.text;
    bool hasMinimumLength = passwordRegex.hasMatch(password);

    if (hasMinimumLength) {
      setState(() {
        passValidator = true;
      });
    }
    if (!hasMinimumLength) {
      setState(() {
        passValidator = false;
      });
    }
  }

  // Use this form key to validate user's input
  final _formKey = GlobalKey<FormState>();

  // Use this to store user inputs
  bool passValidator = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  StreamController<String> _passwordStreamController =
      StreamController<String>();
  final RegExp _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final RegExp _specialNumbRegex = RegExp(r'\d');

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
              const SizedBox(height: 16.0),
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
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your full name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Full Name',
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
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your email';
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
                  border: Border.all(
                      color: !_isFirstTimePressed
                          ? Colors.grey[400]!
                          : passValidator
                              ? Colors.green
                              : Colors.red),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  onTap: () {
                    setState(() {
                      _isFirstTimePressed = true;
                    });
                  },
                  onTapOutside: (event) {
                    setState(() {
                      _isFirstTimePressed = false;
                    });
                  },
                  onChanged: (text) {
                    _passwordStreamController.add(text);
                    isPasswordValid();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
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
              StreamBuilder<String>(
                stream: _passwordStreamController.stream,
                initialData: '',
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  String password = snapshot.data ?? '';
                  return Visibility(
                    visible: _isFirstTimePressed,
                    child: Visibility(
                      visible: !passValidator,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: passwordCharsLeftWidget(context, password),
                      ),
                    ),
                  );
                },
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
                    final FirebaseAuth _auth = FirebaseAuth.instance;
                    res = await Auth.registerWithEmailAndPassword(
                        _emailController.value.text,
                        _passwordController.value.text);
                    if (res == null) {
                      user = _auth.currentUser;
                      var userModel = FirebasePyRegisterModel(
                          firebaseName: _fullNameController.text,
                          firebaseEmail: user?.email,
                          firebaseUid: user?.uid);
                      resPy = await sendPostRegisterRequest(userModel);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: res == null && resPy == 'success'
                            ? Colors.green
                            : Colors.red,
                        content: res == null
                            ? resPy == 'success'
                                ? const Text("Both servers registered you!")
                                : const Text("Registered Successfully!")
                            : const Text("Something wrong!"),
                      ),
                    );
                    if (res == null && resPy == 'success') {
                      Get.offNamed(Routes.HOME);
                    }
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
              if (!_isKeyboardVisible)
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                                    label: Text('Facebook',
                                        style: GoogleFonts.anybody(
                                          color: Colors.white,
                                        )),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: heightWithKeyboard),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.anybody(
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 73, 73, 73)),
                              children: [
                                const TextSpan(
                                    text: "Already have an account? "),
                                TextSpan(
                                  text: "Sign in",
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

  Container passwordCharsLeftWidget(BuildContext context, String password) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.83,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.red,
              blurRadius: 0.5,
              spreadRadius: 0.0,
              offset: Offset(0, 2),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${8 - password.length} characters',
            style: TextStyle(
                color: password.length < 8
                    ? const Color.fromARGB(255, 26, 26, 26)
                    : Colors.transparent),
          ),
          Text(
            '${1 - countSpecialCharacters(password, false)} special',
            style: TextStyle(
                color: countSpecialCharacters(password, false) < 1
                    ? const Color.fromARGB(255, 26, 26, 26)
                    : Colors.transparent),
          ),
          Text(
            '${1 - countSpecialCharacters(password, true)} number',
            style: TextStyle(
                color: countSpecialCharacters(password, true) < 1
                    ? const Color.fromARGB(255, 26, 26, 26)
                    : Colors.transparent),
          ),
        ],
      ),
    );
  }
}

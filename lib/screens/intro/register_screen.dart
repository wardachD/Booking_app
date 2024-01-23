import 'dart:async';
import 'package:findovio/consts.dart';
import 'package:findovio/models/firebase_py_register_model.dart';
import 'package:findovio/providers/api_service.dart';
import 'package:findovio/screens/intro/widgets/social_case_choose.dart';
import 'package:findovio/screens/intro/widgets/text_terms_and_use.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findovio/utilities/authentication/auth.dart';
import '../../routes/app_pages.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
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
  final StreamController<String> _passwordStreamController =
      StreamController<String>();

  @override
  Widget build(BuildContext context) {
    final double topMargin = _isKeyboardVisible ? 50.0 : 150.0;
    final double heightWithKeyboard = _isKeyboardVisible ? 5.0 : 25.0;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.1,
              image: AssetImage('assets/images/intro_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 40),
            curve: Curves.easeIn,
            padding: EdgeInsets.fromLTRB(25, topMargin, 25, 25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: const Text(
                      'Stwórz konto',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Wprowadź swoje dane i szukaj wśród wielu salonów',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 73, 73, 73),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 22.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: TextFormField(
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Imię i nazwisko';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Imię i nazwisko',
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
                          return 'Adres Email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Adres Email',
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
                          width: 1,
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
                          return 'Hasło';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Hasło',
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: passwordCharsLeftWidget(context, password),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15.0),
                  GestureDetector(
                    onTap: () async {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      res = await Auth.registerWithEmailAndPassword(
                          _emailController.value.text,
                          _passwordController.value.text);
                      if (res == null) {
                        user = auth.currentUser;
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
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.orange,
                      ),
                      child: const Text(
                        'Zarejestruj',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (!_isKeyboardVisible)
                    const Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Lub',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 73, 73, 73),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: heightWithKeyboard),
                  if (!_isKeyboardVisible) const SocialCaseChoose(),
                  ConstsWidgets.gapH12,
                  const TextTermsAndUse(),
                ],
              ),
            ),
          ),
        ));
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

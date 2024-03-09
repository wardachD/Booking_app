import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/profile/widgets/profile_widgets.dart';
import 'package:findovio/screens/intro/widgets/popup_status_email_reset.dart';
import 'package:findovio/screens/intro/widgets/social_case_choose.dart';
import 'package:findovio/widgets/popup_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findovio/utilities/authentication/auth.dart';

import '../../routes/app_pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  bool _isEmailNeeded = false;
  bool _resetOKShowHelper = false;

  @override
  void initState() {
    super.initState();
    _isEmailNeeded = false;
    _resetOKShowHelper = false;
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

  // Regexp verificator email
  bool _validateEmail(String email) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final double topMargin = _isKeyboardVisible ? 20.0 : 85.0;
    final double heightWithKeyboard = _isKeyboardVisible ? 5.0 : 25.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        // Szerokość obrazka
                        height: 35,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/logo/logo.png'), // Dopasowanie obrazka do kontenera
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedPadding(
                    padding: EdgeInsets.fromLTRB(25, topMargin, 25, 25),
                    duration: const Duration(milliseconds: 100),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: const Text(
                      'Zaloguj się',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: const Text(
                      'Sporo Cię ominęło',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _resetOKShowHelper
                          ? const Text(
                              '📨 Sprawdź skrzynkę mailową.',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 43, 116, 55)),
                            )
                          : const SizedBox()),
                  const SizedBox(height: 4.0),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: _isEmailNeeded
                              ? Colors.orangeAccent
                              : Colors.grey[400]!),
                    ),
                    child: TextFormField(
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wprowadź swój email';
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
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: TextFormField(
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wprowadź hasło';
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
                  ConstsWidgets.gapH8,
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          _isEmailNeeded = false;
                          _resetOKShowHelper = false;
                        });
                        if (_emailController.text.isEmpty) {
                          setState(() {
                            _isEmailNeeded = true;
                          });
                          return;
                        }
                        if (_emailController.text.isNotEmpty) {
                          var resVerificationEmail =
                              _validateEmail(_emailController.text);
                          if (resVerificationEmail) {
                            try {
                              if (resVerificationEmail) {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: _emailController.text);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const PopupStatusEmailReset(
                                    status: AuthStatus.successful,
                                  ),
                                );
                                setState(() {
                                  _isEmailNeeded = false;
                                  _emailController.text = '';
                                  _resetOKShowHelper = true;
                                });
                              }
                            } catch (e) {
                              AuthStatus status;
                              if (e is FirebaseAuthException) {
                                switch (e.code) {
                                  case 'wrong-password':
                                    status = AuthStatus.wrongPassword;
                                    break;
                                  case 'email-already-in-use':
                                    status = AuthStatus.emailAlreadyExists;
                                    break;
                                  case 'invalid-email':
                                    status = AuthStatus.invalidEmail;
                                    break;
                                  case 'weak-password':
                                    status = AuthStatus.weakPassword;
                                    break;
                                  case 'user-not-found':
                                    status = AuthStatus.userNotFound;
                                    break;
                                  default:
                                    status = AuthStatus.unknown;
                                }
                              } else {
                                status = AuthStatus.unknown;
                              }
                              setState(() {
                                _isEmailNeeded = false;
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    PopupStatusEmailReset(
                                  status: status,
                                ),
                              );
                              setState(() {
                                _resetOKShowHelper = true;
                              });
                            }
                          } else {
                            setState(() {
                              _isEmailNeeded = true;
                            });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const PopupDialog(
                                      title: 'Coś nie tak 🧐',
                                      text:
                                          'Sprawdź swój adres email i spróbuj ponownie.',
                                    ));
                          }
                        }
                      },
                      child: const Text(
                        'Zapomniałeś hasła?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 94, 94, 94),
                            fontSize: 14,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26.0),
                  GestureDetector(
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      var res = await Auth.signInWithEmailAndPassword(
                          _emailController.value.text,
                          _passwordController.value.text);
                      if (mounted) {
                        ProfileWidgets.showDialogLoading(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                res == null ? Colors.black : Colors.black,
                            content: res == null
                                ? const Text("Zalogowano pomyślnie!")
                                : const Text("Zły email/hasło"),
                          ),
                        );
                      }
                      if (res == null) {
                        Get.offAllNamed(Routes.HOME);
                        return;
                      } else {
                        if (mounted) {
                          _emailController.text = '';
                          _passwordController.text = '';
                          Navigator.of(context).pop();
                        }
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
                        'Zaloguj',
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
                            color: Color.fromARGB(255, 73, 73, 73),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: heightWithKeyboard),
                  if (!_isKeyboardVisible)
                    const SocialCaseChoose(
                      enabledButton: true,
                    ),
                  ConstsWidgets.gapH12,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:findovio/consts.dart';
import 'package:findovio/screens/home/profile/widgets/profile_widgets.dart';
import 'package:findovio/screens/intro/widgets/social_case_choose.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findovio/utilities/authentication/auth.dart';

import '../../routes/app_pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
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
    final double topMargin = _isKeyboardVisible ? 130.0 : 150.0;
    final double heightWithKeyboard = _isKeyboardVisible ? 5.0 : 25.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.fromLTRB(25, topMargin, 25, 25),
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
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
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Zapomniałeś hasła?',
                    style: TextStyle(
                        color: Color.fromARGB(255, 94, 94, 94),
                        fontSize: 14,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 26.0),
                GestureDetector(
                  onTap: () async {
                    var res = await Auth.signInWithEmailAndPassword(
                        _emailController.value.text,
                        _passwordController.value.text);
                    ProfileWidgets.showDialogLoading(context);
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
                          fontSize: 16,
                          color: Color.fromARGB(255, 73, 73, 73),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: heightWithKeyboard),
                if (!_isKeyboardVisible) const SocialCaseChoose(),
                ConstsWidgets.gapH12,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

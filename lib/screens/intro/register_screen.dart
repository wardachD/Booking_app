import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:findovio/utilities/authentication/auth.dart';

import '../../routes/app_pages.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with WidgetsBindingObserver {
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
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /*handleSubmit() async {
    // Validate user inputs using formkey
    if (_formKey.currentState!.validate()) {
      // Get inputs from the controllers
      final email = _emailController.value.text;
      final password = _passwordController.value.text;
      // Check if it is login or register
      if (_isLogin) {
        await Auth().signInWithEmailAndPassword(email, password);
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final double topMargin = _isKeyboardVisible ? 50.0 : 150.0;
    final double heightWithKeyboard = _isKeyboardVisible ? 5.0 : 25.0;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, topMargin, 25, 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Hello Again!',
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'Bergamasco',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Welcome back, we \nmissed you!',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 73, 73, 73),
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
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
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
              const SizedBox(height: 24.0),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
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
                    var res = await Auth.registerWithEmailAndPassword(
                        _emailController.value.text,
                        _passwordController.value.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:
                            res == null ? Colors.green : Colors.red,
                        content: res == null
                            ? const Text("Registered Successfully!")
                            : const Text("Something wrong!"),
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
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
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
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 73, 73, 73),
                                thickness: 1.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 73, 73, 73),
                                ),
                              ),
                            ),
                            Expanded(
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
                                  label: const Text('Google',
                                      style: TextStyle(
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
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 73, 73, 73)),
                            children: [
                              TextSpan(text: "Already have an account? "),
                              TextSpan(
                                text: "Sign in",
                                style: TextStyle(fontWeight: FontWeight.bold),
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

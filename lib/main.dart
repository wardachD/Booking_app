import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'package:provider/provider.dart';

Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  // Firebase moved from main thread
  await initializeFirebase();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Stream<User?> authStream = FirebaseAuth.instance.authStateChanges();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authStream,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          final initialRoute = isLoggedIn ? Routes.HOME : Routes.INTRO;

          return GetMaterialApp(
            getPages: AppPages.pages,
            title: 'Findovio',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromARGB(255, 241, 241, 241),
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 245, 138, 38)),
              useMaterial3: true,
            ),
            initialRoute: initialRoute,
          );
        } else {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

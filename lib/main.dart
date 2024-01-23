import 'package:findovio/controllers/user_data_provider.dart';
import 'package:findovio/providers/advertisements_provider.dart';
import 'package:findovio/providers/discover_page_filters.dart';
import 'package:findovio/providers/favorite_salons_provider.dart';
import 'package:findovio/providers/firebase_py_user_provider.dart';
import 'package:findovio/screens/home/discover/provider/animated_top_bar_provider.dart';
import 'package:findovio/screens/home/discover/provider/keywords_provider.dart';
import 'package:findovio/screens/home/discover/provider/optional_category_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:findovio/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'package:provider/provider.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  // Splash
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase moved from main thread
  await initializeFirebase();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // dark text for status bar
      statusBarColor: Colors.transparent));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserDataProvider(),
        ),
        ChangeNotifierProvider(create: (context) => FirebasePyUserProvider()),
        ChangeNotifierProvider(
            create: (context) => DiscoverPageFilterProvider()),
        ChangeNotifierProvider(
          create: (context) => AdvertisementProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteSalonsProvider(),
        ),

        // Discover page
        // Keywords
        ChangeNotifierProvider(create: (_) => KeywordProvider()),
        // Animation
        ChangeNotifierProvider(
          create: (context) => AnimatedTopBarProvider(),
        ),
        // Optional category
        ChangeNotifierProvider(
          create: (context) => OptionalCategoryProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Stream<User?> authStream = FirebaseAuth.instance.authStateChanges();

  @override
  Widget build(BuildContext context) {
    var userProvider =
        Provider.of<FirebasePyUserProvider>(context, listen: false);
    var userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);

    return StreamBuilder<User?>(
      stream: authStream,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        FlutterNativeSplash.remove();
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          final initialRoute = isLoggedIn ? Routes.HOME : Routes.INTRO;

          // Get the user UID if available
          getAvailableUserPyUid(
              isLoggedIn, snapshot, userProvider, userDataProvider);

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            getPages: AppPages.pages,
            title: 'findovio',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 255, 255, 255)),
              useMaterial3: true,
              fontFamily: 'NotoSans',
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

  Future<void> getAvailableUserPyUid(
      bool isLoggedIn,
      AsyncSnapshot<User?> snapshot,
      FirebasePyUserProvider userProvider,
      UserDataProvider userDataProvider) async {
    if (isLoggedIn) {
      final userUid = snapshot.data?.uid;
      if (userUid != null) {
        userProvider.setUserUid(userUid);
      }
      userDataProvider.setUserUid(userUid!);
    }
  }
}

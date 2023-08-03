import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:communicast/providers/user_provider.dart';
import 'package:communicast/responsive/mobile_screen_layout.dart';
import 'package:communicast/responsive/responsive_layout.dart';
import 'package:communicast/responsive/web_screen_layout.dart';
import 'package:communicast/screens/about_screen.dart';
import 'package:communicast/screens/contact_screen.dart';
import 'package:communicast/screens/edit_profile_screen.dart';
import 'package:communicast/screens/forgotPass.dart';
import 'package:communicast/screens/login_screen.dart';
import 'package:communicast/screens/privacy_screen.dart';
import 'package:communicast/screens/tc_screen.dart';
import 'package:communicast/utils/colors.dart';
import 'package:provider/provider.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  // Container(
  //         child: Center(
  //       child: Text(
  //         'Something went wrong',
  //         style: TextStyle(color: Colors.white),
  //         textDirection: TextDirection.ltr,
  //       ),
  //     ));

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAi4JO0jSobsygMpGDX47wjV7YjeF1IO4M",
          appId: "1:480452178298:android:32bd96f51065290167e6c3",
          messagingSenderId: "480452178298",
          projectId: "communicast-app",
          storageBucket: 'communicast-app.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CommuniCast',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: AnimatedSplashScreen(
          splash: Image.asset(
            'assets/images/CommuniCast_Logo.png',
          ),
          nextScreen: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // Checking if the snapshot has any data or not
                if (snapshot.hasData) {
                  // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              // means connection to future hasnt been made yet
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const LoginScreen();
            },
          ),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white,
          duration: 800,
        ),
        onGenerateRoute: (appRoute) {
          switch (appRoute.name) {
            case '/editProfile':
              return PageTransition(
                  child: const EditProfileScreen(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 500));
            case '/forgotPassword':
              return PageTransition(
                  child: const ForgotPassword(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 500));
            case '/termsAndConditions':
              return PageTransition(
                  child: const TermsAndCondition(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 500));
            case '/privacyPolicy':
              return PageTransition(
                  child: const PrivacyPolicyScreen(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 500));
            case '/aboutCommuniCast':
              return PageTransition(
                  child: const AboutScreen(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 500));
            case '/contactUs':
              return PageTransition(
                  child: const ContactUsScreen(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 500));

            default:
              return null;
          }
        },
      ),
    );
  }
}

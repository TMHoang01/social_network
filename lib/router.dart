import 'package:flutter/material.dart';
import 'package:social_network/presentation/screens/signin/sign_in.dart';
import 'package:social_network/presentation/screens/signup/sign_up.dart';
import 'package:social_network/presentation/screens/splash/splash.dart';

class AppRouter {
  static String initialRoute = splash;
  static String get home => '/';
  static String get signUp => '/sign-up';
  static String get signIn => '/sign-in';
  static String get splash => '/splash';

  static Map<String, WidgetBuilder> get routes {
    return <String, WidgetBuilder>{
      signIn: (context) => const SignInScreen(),
      signUp: (context) => const SignUpScreen(),
      splash: (context) => SplashScreen(),
    };
  }
}

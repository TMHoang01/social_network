import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/blocs/signup/signup_bloc.dart';
import 'package:social_network/presentation/blocs/user_infor/user_infor_bloc.dart';
import 'package:social_network/presentation/screens/signin/sign_in.dart';
import 'package:social_network/presentation/screens/signup/sign_up.dart';
import 'package:social_network/presentation/screens/splash/splash.dart';
import 'package:social_network/presentation/screens/user_infor/user_infor.dart';
import 'package:social_network/sl.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Map payload = {};
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    // for background and terminated state
    if (data is RemoteMessage) {
      payload = data.data;
    }
    // for foreground state
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }
    return Scaffold(
      appBar: AppBar(title: Text("Your Message")),
      body: Center(
        child: Text(payload.toString()),
      ),
    );
  }
}

abstract class AppRouter {
  static String initialRoute = splash;
  static String get home => '/';
  static String get signUp => '/sign-up';
  static String get signIn => '/sign-in';
  static String get signUpfor => '/sign-up/infor';

  static String get splash => '/splash';

  static Map<String, WidgetBuilder> get routes {
    return <String, WidgetBuilder>{
      '/message': ((context) => Message()),
      signIn: (context) => const SignInScreen(),
      signUp: (context) {
        final authState = context.read<AuthBloc>().state;
        final signUpBloc = SignupBloc();

        // return SignUpScreen();
        return BlocProvider(
          create: (context) => signUpBloc,
          child: const SignUpScreen(),
        );
      },
      signUpfor: (context) {
        final authState = context.read<AuthBloc>().state;
        final userInforBloc = sl.get<UserInforBloc>();
        if (authState is AuthRegisterNeedInfo) {
          userInforBloc.add(UserInforUpdateRoleInit());
        }
        return BlocProvider(
          create: (context) => userInforBloc,
          child: const SelectUserRoleTypeScreen(),
        );
      },
      splash: (context) => SplashScreen(),
    };
  }
}

class NavigationService {
  bool canPop(BuildContext context) {
    return navigatorKey.currentState!.canPop();
  }

  void pop<T extends Object?>(BuildContext context, [T? result]) {
    navigatorKey.currentState!.pop(result);
  }

  Future<T?> pushNamed<T extends Object?>(
      BuildContext context, String routeName,
      {Object? args}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }

  Future<T?> popAndPushNamed<T extends Object?>(
      BuildContext context, String routeName,
      {Object? args}) {
    return navigatorKey.currentState!
        .popAndPushNamed(routeName, arguments: args);
  }

  void pushNamedAndRemoveUntil(BuildContext context, String routeName) {
    navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }
}

final navService = NavigationService();
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/blocs/signup/signup_bloc.dart';
import 'package:social_network/presentation/blocs/user_infor/user_infor_bloc.dart';
import 'package:social_network/presentation/screens/signin/sign_in.dart';
import 'package:social_network/presentation/screens/signup/sign_up.dart';
import 'package:social_network/presentation/screens/splash/splash.dart';
import 'package:social_network/presentation/screens/user_infor/user_infor.dart';
import 'package:social_network/sl.dart';

abstract class AppRouter {
  static String initialRoute = splash;
  static String get home => '/';
  static String get signUp => '/sign-up';
  static String get signIn => '/sign-in';
  static String get signUpfor => '/sign-up/infor';

  static String get splash => '/splash';

  static Map<String, WidgetBuilder> get routes {
    return <String, WidgetBuilder>{
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
    return Navigator.canPop(context);
  }

  void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  Future<T?> pushNamed<T extends Object?>(
      BuildContext context, String routeName,
      {Object? args}) {
    return Navigator.pushNamed(context, routeName, arguments: args);
  }

  Future<T?> popAndPushNamed<T extends Object?>(
      BuildContext context, String routeName,
      {Object? args}) {
    return Navigator.popAndPushNamed(context, routeName, arguments: args);
  }

  void pushNamedAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }
}

final navService = NavigationService();

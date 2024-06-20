import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/logger.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        logger.d('SplashScreen $state');
        if (state is UnAuthenticated || state is AuthError) {
          logger.d('UhAuthenticated');
          navService.pushNamedAndRemoveUntil(context, AppRouter.signIn);
        } else if (state is AuthRegisterNeedInfo) {
          navService.pushNamedAndRemoveUntil(context, AppRouter.signUpfor);
        } else {}
      },
      child: const Scaffold(
        body: Center(
          child: Text(
            'Splash Screen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

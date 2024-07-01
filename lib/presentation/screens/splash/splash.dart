import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/logger.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
        } else {
          navService.pushNamedAndRemoveUntil(context, AppRouter.home);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: 'assets/images/logo.png',
                height: 200.0,
              ),
              const Center(
                child: Text(
                  'Quản lý chung cư',
                  style: TextStyle(
                    fontSize: 24.0,
                    // color: Colors.white,
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

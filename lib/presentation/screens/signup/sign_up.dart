import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authState = context.watch<AuthBloc>().state;

    var signInWidget = (switch (authState) {
      AuthInitial() => const Text('Sign Up'),
      AuthRegisterLoading() => _buildWidgetLoaing(),
      AuthRegisterSuccess() => const Text('Sign Up'),
      AuthError(error: final msg) => _signUpError(msg),
      _ => const Text('Sign Up'),
    });

    signInWidget = BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          Navigator.pop(context);
        }
        context.read<AuthBloc>().add(AuthLoginPrefilled(
            email: emailController.text, password: passwordController.text));
      },
      child: signInWidget,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Center(
          child: Text('Sign Up'),
        ),
      ),
    );
  }

  Widget _signUpError(String error) => Text('${error} ');

  Widget _buildWidgetLoaing() => const CircularProgressIndicator();
}

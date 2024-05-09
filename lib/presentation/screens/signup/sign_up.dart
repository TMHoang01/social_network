import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/blocs/signup/signup_bloc.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  // final tabController = TabController(length: 2, vsync: null);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final emailController = TextEditingController();
    // final passwordController = TextEditingController();
    final authBloc = context.read<AuthBloc>();

    Widget signInWidget = BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          context.read<AuthBloc>().add(
              SignInRequested(emailController.text, passwordController.text));
          showSnackBar(context, 'Đăng ký tài kkhoản thành công', Colors.green);
        }
      },
      builder: (context, state) {
        return _buildInit();
        return (switch (state) {
          SignupInitial() => _buildInit(),
          // SignupLoading() => _buildWidgetLoaing(),
          SignupSuccess() => const Text('Sign Up'),
          // SignupError(error: final msg) => _signUpError(msg),
          // ignore: unreachable_switch_case
          _ => const Text('Sign Up'),
        });
      },
    );

    signInWidget = BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          if (Navigator.canPop(context)) {
            navService.pop(context);
          } else {
            navService.pushNamedAndRemoveUntil(context, AppRouter.signIn);
          }
          context.read<AuthBloc>().add(AuthLoginPrefilled(
              email: emailController.text, password: passwordController.text));
        } else if (state is AuthRegisterNeedInfo) {
          navService.pushNamed(context, AppRouter.signUpfor);
        }
      },
      child: signInWidget,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
      ),
      body: signInWidget,
    );
  }

  Widget _buildInit() {
    Widget inputEmail = CustomTextFormField(
      controller: emailController,
      hintText: 'Email',
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );

    Widget inputPassword = CustomTextFormField(
      controller: passwordController,
      hintText: 'Password',
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );

    Widget inputConfirmPassword = CustomTextFormField(
      controller: confirmPasswordController,
      hintText: 'Confirm Password',
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your password';
        }
        if (value != passwordController.text) {
          return 'Password does not match';
        }
        return null;
      },
    );

    return Form(
      key: keyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 40),
              child: CustomImageView(
                imagePath: ImageConstant.imgLogo,
                width: 100,
                height: 100,
              ),
            ),
          ),
          inputEmail,
          const SizedBox(height: 10),
          inputPassword,
          const SizedBox(height: 10),
          inputConfirmPassword,
          const SizedBox(height: 10),
          Center(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                bool isLoading = (state is AuthRegisterLoading);
                return CustomButton(
                  onPressed: () {
                    if (isLoading) return;
                    if (keyForm.currentState!.validate()) {
                      context.read<AuthBloc>().add(SignUpRequested(
                          email: emailController.text,
                          password: passwordController.text));
                    } else {
                      showSnackBar(
                          context, 'Vui lòng điền dủ thông tin', Colors.red);
                    }
                  },
                  title: 'Sign Up',
                  prefixWidget: isLoading
                      ? Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(),
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

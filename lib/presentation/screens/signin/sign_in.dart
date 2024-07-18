import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/blocs/signin/signin_cubit.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/app_styles.dart';
import 'package:social_network/utils/constants.dart';
import 'package:social_network/utils/logger.dart';
import 'package:social_network/utils/vadidate/email.dart';
import 'package:social_network/utils/vadidate/password.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninCubit(),
      // create: (context) => SigninCubit(context.read<AuthRepository>()),
      child: const SignInScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    late final authState = context.watch<AuthBloc>().state;
    late final _emailController = TextEditingController(
        text: switch (authState) {
      AuthLoginPrefilled(email: final email) => email,
      _ => '',
    });
    late final _passwordController = TextEditingController(
        text: switch (authState) {
      AuthLoginPrefilled(password: final password) => password,
      _ => '',
    });

    return BlocProvider(
      create: (context) => SigninCubit(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: _buildAppBar(context),
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                // navService.pushNamedAndRemoveUntil(
                //     context, RouterClient.dashboard);
              } else if (state is AuthRegisterNeedInfo) {
                navService.pushNamed(context, AppRouter.signUpfor);
              } else if (state is AuthRegisterNeedVerify) {
                _buildDialogVerify(context);
              } else if (state is AuthError) {
                showSnackBar(context, state.error, Colors.red);
              }
              if (state is UnAuthenticated) {}
            },
            builder: (context, state) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  children: [
                    const FormLogin(),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              navService.pushNamed(context, AppRouter.signUp);
                            },
                            child: Text(
                              "Đăng ký",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style:
                                  appStyle(12, Colors.black, FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 10, right: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6, bottom: 10),
                              child: SizedBox(
                                width: (60),
                                child: Divider(
                                    height: (1),
                                    thickness: (1),
                                    color: kPrimaryColor),
                              ),
                            ),
                            Text(
                              "Đăng nhập với tài khoản khác",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style:
                                  appStyle(12, Colors.black, FontWeight.w400),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 10),
                              child: SizedBox(
                                width: (60),
                                child: Divider(
                                    height: (1), thickness: (1), color: kGray),
                              ),
                            )
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CustomButton(
                        title: "Đăng nhập bằng Google",
                        backgroundColor: kPrimaryColor,
                        prefixWidget: Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: CustomImageView(
                            svgPath: ImageConstant.iconGoogle,
                            height: 20,
                          ),
                        ),
                        onPressed: () {
                          // onTapSigninwithgoogle(context);
                          context.read<AuthBloc>().add(GoogleSignInRequested());
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildDialogVerify(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác thực tài khoản'),
          content: const Text(
              'Vui lòng liên hệ với quản trị viên để xác thực tài khoản của bạn'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
                navService.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Section Widget
}

class FormLogin extends StatelessWidget {
  const FormLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SizedBox(
        width: double.maxFinite,
        // padding:
        //     const EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // build avatar
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
            _builderFormFieldEmail(),
            const SizedBox(height: 10),
            _builderFormFieldPassword(),
            const SizedBox(height: 10),

            BlocListener<SigninCubit, SigninState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == FormzSubmissionStatus.inProgress) {
                  showSnackBar(
                      context, 'Vui lòng điền đủ thông tin', Colors.red);
                }
                if (state.status == FormzSubmissionStatus.failure) {}
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  bool isLoading = (state is AuthLoginLoading);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      // height: 50,
                      title: "Đăng nhập",
                      margin: const EdgeInsets.only(
                        left: 12,
                        top: 10,
                      ),
                      prefixWidget: isLoading
                          ? Transform.scale(
                              scale: 0.5,
                              child: const CircularProgressIndicator(),
                            )
                          : null,
                      onPressed: () {
                        if (isLoading) return;
                        FocusScope.of(context).unfocus();
                        final cubitLogin = context.read<SigninCubit>();
                        cubitLogin.checkValidation();
                        if (cubitLogin.state.isValid) {
                          context.read<AuthBloc>().add(
                                SignInRequested(cubitLogin.state.email.value,
                                    cubitLogin.state.password.value),
                              );
                        } else {
                          logger.i('Form login chưa chuẩn');
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _builderFormFieldEmail() {
    return BlocBuilder<SigninCubit, SigninState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextFormField(
          hintText: "Email",
          textInputAction: TextInputAction.next,
          textInputType: TextInputType.emailAddress,
          errorText: state.email.error == EmailValidationError.invalid
              ? 'Email không hợp lệ'
              : null,
          isObscureText: false,
          onChanged: (value) {
            context.read<SigninCubit>().emailChanged(value);
          },
        );
      },
    );
  }

  Widget _builderFormFieldPassword() {
    return BlocBuilder<SigninCubit, SigninState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.isShowPassword != current.isShowPassword,
      builder: (context, state) {
        return CustomTextFormField(
          hintText: "Mật khẩu",
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          isObscureText: !state.isShowPassword,
          onFieldSubmitted: (_) {
            print('submit complete password');
          },
          errorText: state.password.error == PasswordValidationError.invalid
              ? 'Mật khẩu không hợp lệ'
              : null,
          suffix: InkWell(
            onTap: () {
              context.read<SigninCubit>().togglePasswordVisibility();
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              child: CustomImageView(
                svgPath: context.read<SigninCubit>().state.isShowPassword
                    ? ImageConstant.iconEyeSlash
                    : ImageConstant.iconEye,
              ),
            ),
          ),
          suffixConstraints: const BoxConstraints(maxHeight: (40)),
          onChanged: (value) {
            context.read<SigninCubit>().passwordChanged(value);
          },
        );
      },
    );
  }
}

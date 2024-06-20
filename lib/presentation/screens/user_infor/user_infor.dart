import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/blocs/user_infor/user_infor_bloc.dart';
import 'package:social_network/presentation/screens/user_infor/widget/provider_form.dart';
import 'package:social_network/presentation/screens/user_infor/widget/resident_form.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class SelectUserRoleTypeScreen extends StatefulWidget {
  const SelectUserRoleTypeScreen({super.key});

  @override
  State<SelectUserRoleTypeScreen> createState() =>
      _SelectUserRoleTypeScreenState();
}

class _SelectUserRoleTypeScreenState extends State<SelectUserRoleTypeScreen> {
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBackHome() {
    // check tabcontroller index

    int index = _pageController.page?.toInt() ?? 0;
    if (index != 0) {
      _pageController.animateToPage(index - 1,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      return;
    }

    if (navService.canPop(context)) {
      navService.pop(context);
    } else {
      navService.pushNamedAndRemoveUntil(context, AppRouter.signIn);
    }
    context.read<AuthBloc>().add(SignOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<UserInforBloc, UserInforState>(
      listener: (context, state) {
        // logger.d('UserInforUpdateRoleStarted $state');
        if (state is UserInforUpdateRoleStarted) {
          // pageController is 1
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        } else if (state is UserInforProviderFormStarted) {
          _pageController.animateToPage(1,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        } else if (state is UserInforResidentFormStarted) {
          _pageController.animateToPage(1,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        } else if (state is UserInforUpdateInforSuccess) {
          _dialogBuilder(context);
        } else if (state is UserInforUpdateInforFailure) {
          showSnackBarError(context, 'Cập nhập thông tin thất bại');
          // logger.d('UserInforUpdateInforFailure $state');
        }
      },
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back), onPressed: _onBackHome),
              title: const Text('Đăng ký'),
            ),
            body: Container(
              width: size.width,
              color: kOfWhite,
              child: _buildSelectUserRole(),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back), onPressed: _onBackHome),
              title: const Text('Đăng ký tài khoản'),
            ),
            body: Container(
              width: size.width,
              color: kOfWhite,
              child: _buildFormUserInfor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectUserRole() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Bạn muốn đăng ký tài khoản với tư cách là:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          BlocBuilder<UserInforBloc, UserInforState>(
            buildWhen: (previous, current) {
              if (current is UserInforUpdateRoleStarted) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              bool isResident = false;
              if (state is UserInforUpdateRoleStarted) {
                isResident = (Role.resident == state.role);
              }
              return SelectWidget(
                text: 'Cư dân chung cư',
                isSelect: isResident,
                onChanged: () {
                  context.read<UserInforBloc>().add(
                        const UserInforSelectRoleAccount(role: Role.resident),
                      );
                },
              );
            },
          ),
          BlocBuilder<UserInforBloc, UserInforState>(
            buildWhen: (previous, current) =>
                current is UserInforUpdateRoleStarted,
            builder: (context, state) {
              bool isProvider = false;
              if (state is UserInforUpdateRoleStarted) {
                isProvider = (Role.provider == state.role);
              }
              return SelectWidget(
                text: 'Nhà cung cấp dịch vụ',
                isSelect: isProvider,
                onChanged: () {
                  context.read<UserInforBloc>().add(
                        const UserInforSelectRoleAccount(role: Role.provider),
                      );
                },
              );
            },
          ),
          Expanded(
            child: Container(),
          ),
          CustomButton(
            onPressed: () {
              context.read<UserInforBloc>().add(
                    const UserInforUpdateFormInfor(),
                  );
            },
            title: 'Tiếp theo',
          ),
        ],
      );

  Widget _buildFormUserInfor() {
    return SingleChildScrollView(
      child: BlocBuilder<UserInforBloc, UserInforState>(
        buildWhen: (previous, current) {
          if (current is UserInforResidentFormStarted ||
              current is UserInforProviderFormStarted) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is UserInforProviderFormStarted) {
            return const ProviderFormWidget();
          } else if (state is UserInforResidentFormStarted) {
            return const ResidentFormWidget();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Basic dialog title'),
          content: const Text(
            'Bạn đã đăng ký tài khoản thành công .\nVui lòng liên hệ quản trị viên để kích hoạt tài khoản.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Xác nhận'),
              onPressed: () async {
                final String email = userCurrent?.email ?? '';
                context.read<AuthBloc>().add(SignOutRequested());
                // delay 1s

                context.read<AuthBloc>().add(AuthLoginPrefilled(
                      email: email,
                      password: '',
                    ));
                navService.pushNamedAndRemoveUntil(context, AppRouter.signIn);
                // navService.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

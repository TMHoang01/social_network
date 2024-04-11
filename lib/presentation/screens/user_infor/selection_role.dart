import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/presentation/blocs/user_infor/user_infor_bloc.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';
import 'package:social_network/presentation/widgets/select_widget.dart';

class SlectionRoleUser extends StatelessWidget {
  const SlectionRoleUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          buildWhen: (previous, current) =>
              current is UserInforUpdateRoleStarted,
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
  }
}

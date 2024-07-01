import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isDark = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cài đặt"),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                const _SingleSection(
                  title: "Chung",
                  children: [
                    _CustomListTile(
                        title: "Thông tin tài khoản",
                        icon: Icons.person_outline_rounded),
                    _CustomListTile(
                        title: "Cài đặt thông báo",
                        icon: Icons.notifications_none_rounded),
                    _CustomListTile(
                        title: "Quản lý dịch vụ",
                        icon: Icons.miscellaneous_services_outlined),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "Thông tin chung cư",
                  children: [
                    _CustomListTile(
                        title: "Dịch vụ", icon: Icons.message_outlined),
                    _CustomListTile(
                        title: "Liên hệ", icon: Icons.phone_outlined),
                    _CustomListTile(
                        title: "Điều khoản", icon: Icons.contacts_outlined),
                    // _CustomListTile(
                    //     title: "Lịch trình", icon: Icons.calendar_today_rounded)
                  ],
                ),
                const Divider(),
                _SingleSection(
                  children: [
                    const _CustomListTile(
                        title: "Hỗ trợ & Hỏi đáp",
                        icon: Icons.help_outline_rounded),
                    const _CustomListTile(
                        title: "Giới thiệu", icon: Icons.info_outline_rounded),
                    _CustomListTile(
                      title: "Đăng xuất",
                      icon: Icons.exit_to_app_rounded,
                      onTap: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function? onTap;
  const _CustomListTile(
      {Key? key,
      required this.title,
      required this.icon,
      this.trailing,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}

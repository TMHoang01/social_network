import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/router.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with AutomaticKeepAliveClientMixin {
  int selectedIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              '$selectedIndex',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedIndex++;
              });
            },
            child: const Text('Go to Setting'),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnAuthenticated) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRouter.signIn, (route) => false);
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
                child: const Text('Logout'),
              );
            },
          ),
        ],
      ),
    );
  }
}

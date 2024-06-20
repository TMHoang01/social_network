import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/provider/service/screens/service_booking/service_booking_list_screen.dart';
import 'package:social_network/presentation/resident/dashboard/home_page/home_page.dart';
import 'package:social_network/presentation/resident/dashboard/settings/setting_screen.dart';
import 'package:social_network/presentation/resident/features/service/screens/service_booking/booking_list_screen.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/constants.dart';

class DashBoardClientScreen extends StatefulWidget {
  const DashBoardClientScreen({super.key});

  @override
  State<DashBoardClientScreen> createState() => _DashBoardClientScreenState();
}

class _DashBoardClientScreenState extends State<DashBoardClientScreen> {
  final List<Widget> _pages = [
    const HomePage(),
    const ServiceBookingListScreen(),
    // const MyServiceBookingListScreen(),
    const SettingScreen(),
  ];
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (navService.canPop(context)) {
      navService.pop(context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  onTap(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          navService.pushNamedAndRemoveUntil(context, AppRouter.signIn);
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('DashBoard'),
        // ),
        body: PageView(
          controller: _pageController,
          padEnds: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Đơn đặt',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Cài đặt',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          onTap: onTap,
        ),
      ),
    );
  }
}

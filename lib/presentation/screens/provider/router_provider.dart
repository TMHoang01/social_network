import 'package:flutter/material.dart';
import 'package:social_network/presentation/screens/admins/router_admin.dart';
import 'package:social_network/presentation/screens/provider/dashboard/dashboard.dart';

class RouterProvider extends RouterAdmin {
  static const String initialRoute = dashboard;
  static const String dashboard = '/provider/dashboard';
  static Map<String, WidgetBuilder> routes = {
    ...RouterAdmin.routes,
    dashboard: (context) => const DashboardProviderScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routerA = RouterAdmin.onGenerateRoute(settings);
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text('404 Not Found'),
        ),
      ),
    );
  }
}

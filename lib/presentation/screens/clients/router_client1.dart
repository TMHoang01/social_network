import 'package:flutter/material.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/presentation/screens/admins/products/product_detail.dart';
import 'package:social_network/presentation/screens/admins/products/products_screen.dart';
import 'package:social_network/presentation/screens/clients/cart/cart_screen.dart';
import 'package:social_network/presentation/screens/clients/contact/infor_contact_screen.dart';
import 'package:social_network/presentation/screens/clients/dashboard/dash_board.dart';
import 'package:social_network/presentation/screens/clients/dashboard/home_page/home_page.dart';
import 'package:social_network/presentation/screens/clients/orders/check_out_screen.dart';
import 'package:social_network/presentation/screens/clients/orders/complete_screen.dart';
import 'package:social_network/presentation/screens/clients/orders/orders_details_screen.dart';
import 'package:social_network/presentation/screens/signin/sign_in.dart';
import 'package:social_network/presentation/screens/signup/sign_up.dart';
import 'package:social_network/presentation/screens/splash/splash.dart';

class RouterClient1 {
  static const String initialRoute = dashboard;
  static const String home = '/';
  static const String signUp = '/sign-up';
  static const String signIn = '/sign-in';
  static const String splash = '/splash';
  static const String dashboard = '/dashboard';
  static const String products = '/product';
  static const String productDetail = '/product-detail';
  static const String productEdit = '/product-edit';
  static const String cart = '/cart';
  static const String checkOut = '/check-out';
  static const String contact = '/infor-contact';
  static const String oderDetail = '/order';

  static const String complete = '/complete';

  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    // home: (BuildContext context) => BottomAppBar()
    signIn: (context) => const SignInScreen(),
    signUp: (context) => const SignUpScreen(),
    home: (context) => const HomePage(),
    dashboard: (context) => const DashBoardClientScreen(),
    products: (context) => const ManageProductsScreen(),
    cart: (context) => const CartScreen(),
    checkOut: (context) => const CheckOutScreen(),
    contact: (context) => const InforContactScreen(),
    complete: (context) => const CompleteScreen(),
    oderDetail: (context) => const OrdersDetailWidget(),

    splash: (context) => SplashScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case productDetail:
        return MaterialPageRoute(
          builder: (context) =>
              AdminProductDetail(product: args as ProductModel),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const DashBoardClientScreen(),
        );
    }
  }
}

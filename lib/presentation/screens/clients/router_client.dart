import 'package:flutter/material.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/presentation/screens/admins/products/product_detail.dart';
import 'package:social_network/presentation/screens/admins/products/products_screen.dart';
import 'package:social_network/presentation/screens/clients/services/booking/booking_schedule_screen.dart';
import 'package:social_network/presentation/screens/clients/services/booking/booking_checkout_screen.dart';
import 'package:social_network/presentation/screens/clients/services/booking_form_fill.dart';
import 'package:social_network/presentation/screens/clients/services/service_details_screen.dart';
import 'package:social_network/presentation/screens/clients/services/services_screen.dart';
import 'package:social_network/presentation/screens/clients/cart/cart_screen.dart';
import 'package:social_network/presentation/screens/clients/contact/infor_contact_screen.dart';
import 'package:social_network/presentation/screens/clients/dashboard/dash_board.dart';
import 'package:social_network/presentation/screens/clients/dashboard/home_page/home_page.dart';
import 'package:social_network/presentation/screens/clients/orders/check_out_screen.dart';
import 'package:social_network/presentation/screens/clients/orders/complete_screen.dart';
import 'package:social_network/presentation/screens/clients/posts/post_detail_screen.dart';
import 'package:social_network/presentation/screens/clients/posts/posts_screen.dart';
import 'package:social_network/presentation/screens/splash/splash.dart';
import 'package:social_network/router.dart';

class RouterClient extends AppRouter {
  static const String initialRoute = dashboard;

  static const String home = '/home';
  static const String splash = '/splash';
  static const String dashboard = '/';
  static const String products = '/product';
  static const String productDetail = '/product-detail';
  static const String productEdit = '/product-edit';
  static const String cart = '/cart';
  static const String checkOut = '/check-out';
  static const String contact = '/infor-contact';
  static const String oderDetail = '/order';
  static const String complete = '/complete';

  static const String posts = '/posts';
  static const String postDetail = '/post/detail';

  // Services
  static const String services = '/service/all';
  static const String serviceDetail = '/service/detail';
  static const String servicBookingFormFill = '/service/booking/fill';
  static const String servicBookingFormSchedule = '/service/booking/schedule';
  static const String servicBookingCheckout = '/service/booking/checkout';

  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes {
    return <String, WidgetBuilder>{
      // home: (BuildContext context) => BottomAppBar()

      // signIn: (context) => const SignInScreen(),
      // signUp: (context) => const SignUpScreen(),
      ...AppRouter.routes,
      splash: (context) => SplashScreen(),

      home: (context) => const HomePage(),
      dashboard: (context) => const DashBoardClientScreen(),
      products: (context) => const ManageProductsScreen(),
      cart: (context) => const CartScreen(),
      checkOut: (context) => const CheckOutScreen(),
      contact: (context) => const InforContactScreen(),
      complete: (context) => const CompleteScreen(),
      // oderDetail: (context) => const OrdersDetailWidget(),
      posts: (context) => const PostsScreen(),

      services: (context) => const ServicesScreen(),
      servicBookingFormFill: (context) => const BookingFormFillScreen(),
      servicBookingFormSchedule: (context) => const BookingScheduleScreen(),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case productDetail:
        return MaterialPageRoute(
          builder: (context) =>
              AdminProductDetail(product: args as ProductModel),
        );
      case postDetail:
        return MaterialPageRoute(
          builder: (context) => PostDetailScreen(post: args as PostModel),
        );

      case serviceDetail:
        return MaterialPageRoute(
          builder: (context) =>
              ServiceDetailScreen(service: args as ServiceModel),
        );
      case servicBookingCheckout:
        return MaterialPageRoute(
          builder: (context) =>
              BookingCheckoutScreen(booking: args as BookingService),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const DashBoardClientScreen(),
        );
    }
  }
}

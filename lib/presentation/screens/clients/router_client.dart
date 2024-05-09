import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/domain/models/feed_back/feed_back.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/presentation/blocs/admins/products/product_bloc.dart';
import 'package:social_network/presentation/screens/admins/products/product_detail.dart';
import 'package:social_network/presentation/screens/admins/products/products_screen.dart';
import 'package:social_network/presentation/screens/admins/employee/employee_select_screen.dart';
import 'package:social_network/presentation/screens/clients/feed_back/feed_back_detail_screen.dart';
import 'package:social_network/presentation/screens/clients/feed_back/feed_back_form_screen.dart';
import 'package:social_network/presentation/screens/clients/feed_back/feed_back_list_screen.dart';
import 'package:social_network/presentation/screens/clients/services/booking/booking_schedule_screen.dart';
import 'package:social_network/presentation/screens/clients/services/booking/booking_checkout_screen.dart';
import 'package:social_network/presentation/screens/clients/services/booking_form_fill.dart';
import 'package:social_network/presentation/screens/clients/services/my_shedule_screen.dart';
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
import 'package:social_network/sl.dart';

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
  static const String postCreate = '/post/create';

  // Services
  static const String services = '/service/all';
  static const String serviceDetail = '/service/detail';
  static const String servicBookingFormFill = '/service/booking/fill';
  static const String servicBookingFormSchedule = '/service/booking/schedule';
  static const String servicBookingCheckout = '/service/booking/checkout';

  // Schedule
  static const String mySchedule = '/my-schedule';

  // feedback
  static const String feedback = '/feedback';
  static const String feedbackDetail = '/feedback/detail';
  static const String feedbackCreate = '/feedback/create';

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
      products: (context) => BlocProvider(
            create: (context) => sl.get<ManageProductBloc>(),
            child: const ManageProductsScreen(),
          ),
      cart: (context) => const CartScreen(),
      checkOut: (context) => const CheckOutScreen(),
      contact: (context) => const InforContactScreen(),
      complete: (context) => const CompleteScreen(),
      // oderDetail: (context) => const OrdersDetailWidget(),
      posts: (context) => const PostsScreen(),
      // service
      services: (context) => const ServicesScreen(),
      servicBookingFormFill: (context) => const BookingFormFillScreen(),
      servicBookingFormSchedule: (context) => const BookingScheduleScreen(),

      // schedule
      mySchedule: (context) => const MyScheduleScreen(),

      // feedback
      feedback: (context) => const FeedBackListScreen(),
      // feedbackDetail: (context) => const FeedBackDetailScreen(),
      feedbackCreate: (context) => const FeedBackFormScreen(),
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

      case feedbackDetail:
        return MaterialPageRoute(
          builder: (context) =>
              FeedBackDetailsScreen(item: args as FeedBackModel),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const DashBoardClientScreen(),
        );
    }
  }
}

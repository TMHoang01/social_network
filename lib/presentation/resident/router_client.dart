import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/domain/models/feed_back/feed_back.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/presentation/provider/ecom/blocs/products/product_bloc.dart';
import 'package:social_network/presentation/resident/features/ecom/screens/cart/cart_screen.dart';
import 'package:social_network/presentation/provider/ecom/screens/product_detail.dart';
import 'package:social_network/presentation/provider/ecom/screens/products_screen.dart';
import 'package:social_network/presentation/provider/service/screens/service_booking/service_booking_detail_screen.dart';
import 'package:social_network/presentation/resident/contact/screens/infor_contact_screen.dart';

import 'package:social_network/presentation/resident/dashboard/dash_board.dart';
import 'package:social_network/presentation/resident/dashboard/home_page/home_page.dart';
import 'package:social_network/presentation/resident/features/ecom/screens/products/products_screen.dart';
import 'package:social_network/presentation/resident/features/feed_back/screens/feed_back_detail_screen.dart';
import 'package:social_network/presentation/resident/features/feed_back/screens/feed_back_form_screen.dart';
import 'package:social_network/presentation/resident/features/feed_back/screens/feed_back_list_screen.dart';
import 'package:social_network/presentation/resident/features/guest_access/screens/guest_access_detail_screen.dart';
import 'package:social_network/presentation/resident/features/guest_access/screens/guest_access_form_screen.dart';
import 'package:social_network/presentation/resident/features/guest_access/screens/guest_access_list_creen.dart';

import 'package:social_network/presentation/resident/features/post/screens/post_detail_screen.dart';
import 'package:social_network/presentation/resident/features/post/screens/posts_screen.dart';
import 'package:social_network/presentation/resident/features/service/screens/service_booking/widgets/booking_checkout_screen.dart';
import 'package:social_network/presentation/resident/features/service/screens/service_booking/booking_detail_screen.dart';
import 'package:social_network/presentation/resident/features/service/screens/service_booking/booking_list_screen.dart';
import 'package:social_network/presentation/resident/features/service/screens/service_booking/booking_schedule_screen.dart';
import 'package:social_network/presentation/resident/features/service/screens/service_booking/booking_form_fill.dart';
import 'package:social_network/presentation/resident/features/service/screens/services/my_shedule_screen.dart';
import 'package:social_network/presentation/resident/features/service/screens/services/review_service_screen.dart';
import 'package:social_network/presentation/resident/features/service/screens/services/service_details_screen.dart';
import 'package:social_network/presentation/resident/features/service/screens/services/services_screen.dart';
import 'package:social_network/presentation/resident/features/ecom/screens/orders/check_out_screen.dart';
import 'package:social_network/presentation/resident/features/ecom/screens/orders/complete_screen.dart';
import 'package:social_network/presentation/resident/parking/screens/paking/parking_map_screen.dart';
import 'package:social_network/presentation/resident/parking/screens/vehicle/form_resgiter_vehicle_screen.dart';
import 'package:social_network/presentation/resident/parking/screens/vehicle/list_my_vehicle_screen.dart';
import 'package:social_network/presentation/screens/splash/splash.dart';
import 'package:social_network/router.dart';
import 'package:social_network/sl.dart';

class RouterClient extends AppRouter {
  static const String initialRoute = home;

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
  static const String bookingList = '/booking/list';
  static const String bookingDetail = '/booking/detail';
  static const String serviceReviews = '/service/reviews';

  // Schedule
  static const String mySchedule = '/my-schedule';

  // feedback
  static const String feedback = '/feedback';
  static const String feedbackDetail = '/feedback/detail';
  static const String feedbackCreate = '/feedback/create';

  // parking vehicle
  static const String parking = '/parking';
  static const String parkingDetail = '/parking/detail';
  static const String parkingVehicle = '/parking/my-vehicle/list';
  static const String parkingVehicleDetail = '/parking/my-vehicle/detail';
  static const String parkingVehicleCreate = '/parking/my-vehicle/create';
  static const String parkingVehicleEdit = '/parking/my-vehicle/edit';

  // guest access
  static const String guestAccess = '/guest-access';
  static const String guestAccessAdd = '/guest-access/add';
  static const String guestAccessEdit = '/guest-access/edit';
  static const String guestAccessDetail = '/guest-access/detail';

  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes {
    return <String, WidgetBuilder>{
      '/message': ((context) => Message()),

      // home: (BuildContext context) => BottomAppBar()

      // signIn: (context) => const SignInScreen(),
      // signUp: (context) => const SignUpScreen(),
      ...AppRouter.routes,
      splash: (context) => SplashScreen(),

      // home: (context) => const HomePage(),
      dashboard: (context) => const DashBoardClientScreen(),
      products: (context) => BlocProvider(
            create: (context) => sl.get<ManageProductBloc>(),
            child: const ProductsScreen(),
          ),
      cart: (context) => const CartScreen(),
      checkOut: (context) => const CheckOutScreen(),
      contact: (context) => const InforContactScreen(),
      complete: (context) => const CompleteScreen(),
      // oderDetail: (context) => const OrdersDetailWidget(),
      posts: (context) => const PostsScreen(),
      // service
      services: (context) => const ServicesScreen(),
      serviceReviews: (context) => const ReviewsServiceScreen(),
      servicBookingFormSchedule: (context) => const BookingScheduleScreen(),

      // schedule
      mySchedule: (context) => const MyScheduleScreen(),

      // feedback
      feedback: (context) => const FeedBackListScreen(),
      // feedbackDetail: (context) => const FeedBackDetailScreen(),
      feedbackCreate: (context) => const FeedBackFormScreen(),

      // parking
      parkingVehicle: (context) => const ListMyVehicleScreen(),
      parkingVehicleCreate: (context) => const FormResgitterVehicleScreen(),
      parking: (context) => const ParkingMapScreen(),

      // guest access
      guestAccess: (context) => const GuestAccessListScreen(),
      guestAccessAdd: (context) => const GuestAccessFormScreen(),
      guestAccessDetail: (context) => const GuestAccessDetailScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/admin/booking/detail":
        return MaterialPageRoute(
          builder: (context) =>
              ServiceBookingDetailScreen(booking: args as BookingService),
        );
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
      case servicBookingFormFill:
        return MaterialPageRoute(
          builder: (context) =>
              BookingFormFillScreen(service: args as ServiceModel),
        );
      // booking
      case bookingList:
        return MaterialPageRoute(
          builder: (context) => const MyServiceBookingListScreen(),
        );

      case bookingDetail:
        return MaterialPageRoute(
          builder: (context) =>
              BookingCheckDetailScreen(booking: args as BookingService),
        );

      case feedbackDetail:
        return MaterialPageRoute(
          builder: (context) =>
              FeedBackDetailsScreen(item: args as FeedBackModel),
        );
    }
    return null;
  }
}

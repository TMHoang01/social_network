import 'package:flutter/material.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/presentation/blocs/admins/post_form/post_form_bloc.dart';
import 'package:social_network/presentation/screens/admins/dashboard/dash_board.dart';
import 'package:social_network/presentation/screens/admins/dashboard/post/posts_screen.dart';
import 'package:social_network/presentation/screens/admins/posts/post_create_screen.dart';
import 'package:social_network/presentation/screens/admins/posts/post_detail_screen.dart';
import 'package:social_network/presentation/screens/admins/products/form/product_detail_form.dart';
import 'package:social_network/presentation/screens/admins/products/product_detail.dart';
import 'package:social_network/presentation/screens/admins/products/products_screen.dart';
import 'package:social_network/presentation/screens/admins/services/service_details_screen.dart';
import 'package:social_network/presentation/screens/admins/services/service_form_screen.dart';
import 'package:social_network/presentation/screens/admins/services/service_screen.dart';
import 'package:social_network/presentation/screens/admins/users/user_details_screen.dart';
import 'package:social_network/presentation/screens/admins/users/users_screen.dart';
import 'package:social_network/router.dart';

class RouterAdmin extends AppRouter {
  static const String initialRoute = dashboard;
  static const String splash = '/splash';
  static const String dashboard = '/admin/dashboard';
  static const String products = '/admin/product/list';
  static const String productDetail = '/admin/product/detail';
  static const String productEdit = '/admin/product/edit';
  static const String productAdd = '/admin/product/add';

  static const String post = '/admin/post';
  static const String postDetail = '/admin/post/detail';
  static const String postEdit = '/admin/post/edit';
  static const String postAdd = '/admin/post/add';
  static const String oderDetail = '/admin/order';

  static const String users = '/admin/user/list';
  static const String userDetail = '/admin/user/detail';

  static const String services = '/admin/service';
  static const String serviceDetail = '/service/detail';
  static const String serviceEdit = '/admin/service/edit';
  static const String serviceAdd = '/admin/service/add';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    // home: (BuildContext context) => BottomAppBar()
    ...AppRouter.routes,
    dashboard: (context) => const DashBoarAdmindScreen(),
    products: (context) => const ManageProductsScreen(),
    productAdd: (context) => const ProductFormDetail(),
    post: (context) => const PostsScreen(),
    users: (context) => const UsersScreen(),
    services: (context) => const ServicesScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case productDetail:
        return MaterialPageRoute(
          builder: (context) =>
              AdminProductDetail(product: args as ProductModel),
        );
      case productEdit:
        return MaterialPageRoute(
          builder: (context) =>
              ProductFormDetail(product: args as ProductModel),
        );

      case postAdd:
        return MaterialPageRoute(
          builder: (context) => PostCreateScreen(bloc: args as PostFormBloc),
        );
      case postDetail:
        return MaterialPageRoute(
          builder: (context) => PostDetailScreen(post: args as PostModel),
        );

      case userDetail:
        return MaterialPageRoute(
          builder: (context) => UserDetailScreen(user: args as UserModel),
        );

      case serviceAdd:
        return MaterialPageRoute(
          builder: (context) => const ServiceFormScreen(),
        );
      case serviceEdit:
        return MaterialPageRoute(
          builder: (context) =>
              ServiceFormScreen(service: args as ServiceModel),
        );
      case serviceDetail:
        return MaterialPageRoute(
          builder: (context) =>
              ServiceDetailScreen(service: args as ServiceModel),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const DashBoarAdmindScreen(),
        );
    }
  }
}

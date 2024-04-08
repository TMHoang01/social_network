import 'package:flutter/material.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/presentation/blocs/admins/post_create/post_create_bloc.dart';
import 'package:social_network/presentation/screens/admins/dashboard/dash_board.dart';
import 'package:social_network/presentation/screens/admins/posts/post_create_screen.dart';
import 'package:social_network/presentation/screens/admins/products/product_detail.dart';
import 'package:social_network/presentation/screens/admins/products/form/product_detail_form.dart';
import 'package:social_network/presentation/screens/admins/products/products_screen.dart';
import 'package:social_network/presentation/screens/admins/users/user_details_screen.dart';
import 'package:social_network/presentation/screens/admins/users/users_screen.dart';

import 'package:social_network/presentation/screens/splash/splash.dart';
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

  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    // home: (BuildContext context) => BottomAppBar()
    ...AppRouter.routes,
    dashboard: (context) => const DashBoarAdmindScreen(),
    products: (context) => const ManageProductsScreen(),
    productAdd: (context) => const ProductFormDetail(),

    users: (context) => const UsersScreen(),
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
          builder: (context) => PostCreateScreen(bloc: args as PostCreateBloc),
        );
      case userDetail:
        return MaterialPageRoute(
          builder: (context) => UserDetailScreen(user: args as UserModel),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const DashBoarAdmindScreen(),
        );
    }
  }
}

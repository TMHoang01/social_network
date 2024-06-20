import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/main.dart';
import 'package:social_network/presentation/provider/ecom/blocs/category/category_bloc.dart';
import 'package:social_network/presentation/provider/blocs/employees/employees_bloc.dart';
import 'package:social_network/presentation/provider/feed_back/blocs/feed_backs/feed_backs_bloc.dart';
import 'package:social_network/presentation/provider/post/blocs/posts/posts_bloc.dart';
import 'package:social_network/presentation/provider/ecom/blocs/products/product_bloc.dart';
import 'package:social_network/presentation/provider/service/blocs/service_booking/service_booking_bloc.dart';
import 'package:social_network/presentation/provider/service/blocs/services_my/my_services_bloc.dart';
import 'package:social_network/presentation/provider/blocs/users/users_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/provider/screens/router_admin.dart';
import 'package:social_network/sl.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ManageProductBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(GetCategoriesEvent()),
        ),
        BlocProvider(create: (context) => sl<PostsBloc>()..add(PostsStarted())),
        BlocProvider(create: (_) => sl<UsersBloc>()..add(UsersGetAllUsers())),
        BlocProvider(create: (_) => sl<MyServicesBloc>()),
        BlocProvider(
            create: (_) => sl<FeedBacksBloc>()..add(FeedBacksStarted())),
        BlocProvider(create: (_) => sl<EmployeesBloc>()),
        BlocProvider(create: (_) => sl<ServiceBookingBloc>()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // sl<CategoryBloc>().add(GetCategoriesEvent());
          return MyMaterialApp(
            initialRoute: RouterAdmin.initialRoute,
            routes: RouterAdmin.routes,
            onGenerateRoute: RouterAdmin.onGenerateRoute,
          );
        },
      ),
    );
  }
}

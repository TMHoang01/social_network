import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/data/datasources/ecom/category_repository.dart';
import 'package:social_network/data/datasources/ecom/infor_contact_remote.dart';
import 'package:social_network/data/datasources/ecom/order_remote.dart';
import 'package:social_network/data/datasources/ecom/product_repository.dart';
import 'package:social_network/data/datasources/user_remote.dart';
import 'package:social_network/main.dart';
import 'package:social_network/presentation/blocs/admins/category/category_bloc.dart';
import 'package:social_network/presentation/blocs/admins/posts/posts_bloc.dart';
import 'package:social_network/presentation/blocs/admins/products/product_bloc.dart';
import 'package:social_network/presentation/blocs/admins/users/users_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/screens/admins/router_admin.dart';
import 'package:social_network/sl.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => sl<InforContactRemote>()),
        RepositoryProvider(create: (context) => sl<OrderRemote>()),
        RepositoryProvider(create: (context) => sl<ProductRemote>()),
        RepositoryProvider(create: (context) => sl<CategoryRemote>()),
        RepositoryProvider(create: (_) => sl<UserRemote>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<ManageProductBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<CategoryBloc>(),
          ),
          BlocProvider(
              create: (context) => sl.get<PostsBloc>()..add(PostsStarted())),
          BlocProvider(create: (_) => sl<UsersBloc>()..add(UsersGetAllUsers())),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            sl<CategoryBloc>().add(GetCategoriesEvent());
            return MyMaterialApp(
              initialRoute: RouterAdmin.initialRoute,
              routes: RouterAdmin.routes,
              onGenerateRoute: RouterAdmin.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}

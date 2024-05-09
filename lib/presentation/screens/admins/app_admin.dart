import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/main.dart';
import 'package:social_network/presentation/blocs/admins/category/category_bloc.dart';
import 'package:social_network/presentation/blocs/admins/employee_form/employee_form_bloc.dart';
import 'package:social_network/presentation/blocs/admins/employees/employees_bloc.dart';
import 'package:social_network/presentation/blocs/admins/feed_backs/feed_backs_bloc.dart';
import 'package:social_network/presentation/blocs/admins/posts/posts_bloc.dart';
import 'package:social_network/presentation/blocs/admins/products/product_bloc.dart';
import 'package:social_network/presentation/blocs/admins/services/services_bloc.dart';
import 'package:social_network/presentation/blocs/admins/users/users_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/screens/admins/router_admin.dart';
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
        BlocProvider(create: (_) => sl<ServicesBloc>()..add(ServicesStarted())),
        BlocProvider(
            create: (_) => sl<FeedBacksBloc>()..add(FeedBacksStarted())),
        BlocProvider(
          create: (_) => sl<EmployeeFormBloc>(),
        ),
        BlocProvider(create: (_) => sl<EmployeesBloc>()),
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

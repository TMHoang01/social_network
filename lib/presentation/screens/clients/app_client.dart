import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/data/datasources/ecom/cart_remote.dart';
import 'package:social_network/data/datasources/ecom/category_repository.dart';
import 'package:social_network/data/datasources/ecom/infor_contact_remote.dart';
import 'package:social_network/data/datasources/ecom/order_remote.dart';
import 'package:social_network/data/datasources/file_store.dart';
import 'package:social_network/domain/repository/ecom/category_repository.dart';
import 'package:social_network/domain/repository/ecom/product_repository.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/firebase_options.dart';
import 'package:social_network/main.dart';
import 'package:social_network/presentation/blocs/admins/category/category_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/blocs/clients/cart/cart_bloc.dart';
import 'package:social_network/presentation/blocs/clients/infor_contact/infor_contact_bloc.dart';
import 'package:social_network/presentation/blocs/clients/order/order_bloc.dart';
import 'package:social_network/presentation/blocs/clients/products/product_bloc.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/logger.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    logger.d(
        'transition  ${bloc.runtimeType}:\n  ${transition.currentState.runtimeType} -> ${transition.event.runtimeType}  -> ${transition.nextState.runtimeType}');
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    logger.d('event ${bloc.runtimeType}: $event');
    super.onEvent(bloc, event);
  }

  @override
  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc.observer = SimpleBlocDelegate();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocator();

  runApp(const ClientApp());
}

final CategoryRepository categoryRepository = CategoryRemote();
final FileRepository fileRepository = FileStoreIml();

class ClientApp extends StatelessWidget {
  const ClientApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => categoryRepository),
        RepositoryProvider(create: (context) => fileRepository),
        RepositoryProvider(create: (context) => sl<ProductRepository>()),
        RepositoryProvider(create: (context) => sl<CartRemote>()),
        RepositoryProvider(create: (context) => sl<InforContactRemote>()),
        RepositoryProvider(create: (context) => sl<OrderRemote>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CategoryBloc(
              categoryRepository: context.read<CategoryRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              productRepository: context.read<ProductRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => sl<CartBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<InforContactBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<OrderBloc>(),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              context.read<CategoryBloc>().add(GetCategoriesEvent());
              context.read<CartBloc>().add(GetCart());
              context.read<InforContactBloc>().add(GetInforContact());
              context.read<OrderBloc>().add(const GetAllOrder());
            }
            return MyMaterialApp(
              initialRoute: RouterClient.initialRoute,
              routes: RouterClient.routes,
              onGenerateRoute: RouterClient.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}

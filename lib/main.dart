import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_network/data/datasources/auth_remote.dart';
import 'package:social_network/data/datasources/ecom/category_repository.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/domain/repository/ecom/order_repository.dart';
import 'package:social_network/domain/repository/ecom/product_repository.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/domain/repository/service/service_repository.dart';
import 'package:social_network/domain/repository/user_repository.dart';
import 'package:social_network/firebase_options.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/provider/screens/app_admin.dart';
import 'package:social_network/presentation/resident/app_client.dart';
import 'package:social_network/router.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/constants.dart';
import 'package:social_network/utils/firebase.dart';
import 'package:social_network/utils/logger.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    logger.d('bloc transition  ${bloc.runtimeType}:\n'
        'bloc   ${transition.currentState.runtimeType} ->'
        'event ${transition.event.runtimeType} '
        'bloc -> ${transition.nextState.runtimeType}');
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    // logger.d('event ${bloc.runtimeType}: $event');
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
  Bloc.observer = SimpleBlocDelegate();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocator();

  await geFireBaseMessaging();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => sl<AuthFirebase>()),
        RepositoryProvider(create: (_) => sl<OrderRepository>()),
        RepositoryProvider(create: (_) => sl<ProductRepository>()),
        RepositoryProvider(create: (_) => sl<CategoryRemote>()),
        RepositoryProvider(create: (_) => sl<UserRepository>()),
        RepositoryProvider(create: (_) => sl<FileRepository>()),
        RepositoryProvider(create: (_) => sl<ServiceRepository>()),
      ],
      child: BlocProvider(
        create: (context) => sl<AuthBloc>()..add(CheckAuthRequested()),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              switch (state.user.roles) {
                case Role.provider:
                  return const AdminApp();
                case Role.user:
                  return const ClientApp();
                default:
                  return const ClientApp();
              }
            } else {
              return MyMaterialApp(
                initialRoute: AppRouter.initialRoute,
                routes: AppRouter.routes,
              );
            }
          },
        ),
      ),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;
  final dynamic onGenerateRoute;
  const MyMaterialApp({
    super.key,
    required this.initialRoute,
    required this.routes,
    this.onGenerateRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Network',
      locale: const Locale('vi', 'VN'),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryColor,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: kOfWhite,
              width: 1,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: Colors.white,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
      initialRoute: initialRoute,
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}

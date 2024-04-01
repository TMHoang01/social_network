import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_network/data/datasources/auth_remote.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/firebase_options.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/screens/admins/app_admin.dart';
import 'package:social_network/presentation/screens/clients/app_client.dart';
import 'package:social_network/router.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/constants.dart';
import 'package:social_network/utils/logger.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    logger.d('transition  ${bloc.runtimeType}:\n'
        '  ${transition.currentState.runtimeType} -> ${transition.event.runtimeType} '
        ' -> ${transition.nextState.runtimeType}');
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => sl<AuthFirebase>(),
      child: BlocProvider(
        create: (context) => sl<AuthBloc>()..add(CheckAuthRequested()),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              switch (state.user.roles) {
                case Role.admin:
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
      ),
      initialRoute: initialRoute,
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/data/datasources/ecom/category_repository.dart';
import 'package:social_network/domain/repository/ecom/cart_repository.dart';
import 'package:social_network/domain/repository/ecom/category_repository.dart';
import 'package:social_network/domain/repository/ecom/infor_contact_repository.dart';
import 'package:social_network/domain/repository/ecom/product_repository.dart';
import 'package:social_network/firebase_options.dart';
import 'package:social_network/main.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/provider/ecom/blocs/category/category_bloc.dart';
import 'package:social_network/presentation/provider/service/blocs/service_booking/service_booking_bloc.dart';
import 'package:social_network/presentation/resident/contact/blocs/infor_contact/infor_contact_bloc.dart';
import 'package:social_network/presentation/resident/features/ecom/blocs/cart/cart_bloc.dart';
import 'package:social_network/presentation/resident/features/ecom/blocs/order/order_bloc.dart';
import 'package:social_network/presentation/resident/features/ecom/blocs/products/product_bloc.dart';
import 'package:social_network/presentation/resident/features/feed_back/blocs/my_feed_back/my_feed_back_bloc.dart';
import 'package:social_network/presentation/resident/features/feed_back/blocs/my_feed_back_create/my_feed_back_create_bloc.dart';
import 'package:social_network/presentation/resident/features/post/blocs/posts/posts_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/booking_service/booking_service_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/service_detail/service_detail_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/services/services_bloc.dart';
import 'package:social_network/presentation/resident/parking/blocs/my_vehicle/vehicle_list_bloc.dart';
import 'package:social_network/presentation/resident/parking/blocs/parking/parking_bloc.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/sl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc.observer = SimpleBlocDelegate();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocator();

  runApp(const ClientApp());
}

final CategoryRepository categoryRepository = CategoryRemote();

class ClientApp extends StatelessWidget {
  const ClientApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => categoryRepository),
        RepositoryProvider(create: (context) => sl<CartRepository>()),
        RepositoryProvider(create: (context) => sl<InforContactRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          // ecoms
          BlocProvider(
            create: (context) => CategoryBloc(
                categoryRepository: context.read<CategoryRepository>()),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
                productRepository: context.read<ProductRepository>()),
          ),
          BlocProvider(create: (context) => sl<CartBloc>()),
          BlocProvider(create: (context) => sl<InforContactBloc>()),
          BlocProvider(create: (context) => sl<OrderBloc>()),

          // posts
          BlocProvider(
            create: (context) => sl.get<PostsClientBloc>()..add(PostsStarted()),
          ),
          // services
          BlocProvider(create: (_) => sl<ServicesBloc>()),
          BlocProvider(create: (_) => sl<ServiceDetailBloc>()),
          BlocProvider(create: (_) => sl<BookingServiceBloc>()),
          BlocProvider(create: (_) => sl<BookingServiceCreateBloc>()),
          // booking
          BlocProvider(create: (_) => sl<ServiceBookingBloc>()),

          // feedback
          BlocProvider(create: (_) => sl<MyFeedBackBloc>()),
          BlocProvider(create: (_) => sl<MyFeedBackCreateBloc>()),

          // parking
          BlocProvider(create: (_) => sl<MyVehicleBloc>()),
          BlocProvider(create: (_) => sl<ParkingBloc>()),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              context.read<InforContactBloc>().add(GetInforContact());
              // context.read<CategoryBloc>().add(GetCategoriesEvent());
              // context.read<CartBloc>().add(GetCart());
              // context.read<OrderBloc>().add(const GetAllOrder());
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_network/data/datasources/auth_remote.dart';
import 'package:social_network/data/datasources/ecom/cart_remote.dart';
import 'package:social_network/data/datasources/ecom/category_repository.dart';
import 'package:social_network/data/datasources/ecom/infor_contact_remote.dart';
import 'package:social_network/data/datasources/ecom/order_remote.dart';
import 'package:social_network/data/datasources/ecom/post_remote.dart';
import 'package:social_network/data/datasources/ecom/product_repository.dart';
import 'package:social_network/data/datasources/feed_back/feed_back_remote.dart';
import 'package:social_network/data/datasources/file_store.dart';
import 'package:social_network/data/datasources/manage/employee_remote.dart';
import 'package:social_network/data/datasources/service/booking_service_remote.dart';
import 'package:social_network/data/datasources/service/service_remote.dart';
import 'package:social_network/data/datasources/user_remote.dart';
import 'package:social_network/data/repository/auth_repository.dart';
import 'package:social_network/data/repository/ecom/cart_repository.dart';
import 'package:social_network/data/repository/ecom/category_repository.dart';
import 'package:social_network/data/repository/ecom/infor_contact_repository.dart';
import 'package:social_network/data/repository/ecom/order_repository.dart';
import 'package:social_network/data/repository/ecom/product_repository.dart';
import 'package:social_network/data/repository/post/post_repository.dart';
import 'package:social_network/data/repository/user_repository.dart';
import 'package:social_network/domain/repository/auth_repository.dart';
import 'package:social_network/domain/repository/ecom/cart_repository.dart';
import 'package:social_network/domain/repository/ecom/category_repository.dart';
import 'package:social_network/domain/repository/ecom/infor_contact_repository.dart';
import 'package:social_network/domain/repository/ecom/order_repository.dart';
import 'package:social_network/domain/repository/ecom/product_repository.dart';
import 'package:social_network/domain/repository/feed_back/feed_back_repository.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/domain/repository/manage/employee_repository.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';
import 'package:social_network/domain/repository/service/booking_repository.dart';
import 'package:social_network/domain/repository/service/service_repository.dart';
import 'package:social_network/domain/repository/user_repository.dart';
import 'package:social_network/presentation/blocs/admins/category/category_bloc.dart';
import 'package:social_network/presentation/blocs/admins/employee_form/employee_form_bloc.dart';
import 'package:social_network/presentation/blocs/admins/employees/employees_bloc.dart';
import 'package:social_network/presentation/blocs/admins/feed_back_detail/feed_back_detail_bloc.dart';
import 'package:social_network/presentation/blocs/admins/feed_backs/feed_backs_bloc.dart';
import 'package:social_network/presentation/blocs/admins/post_detail/post_detail_bloc.dart';
import 'package:social_network/presentation/blocs/admins/post_form/post_form_bloc.dart';
import 'package:social_network/presentation/blocs/admins/posts/posts_bloc.dart';
import 'package:social_network/presentation/blocs/admins/products/product_bloc.dart';
import 'package:social_network/presentation/blocs/admins/service_booking/service_booking_bloc.dart';
import 'package:social_network/presentation/blocs/admins/service_form/service_form_bloc.dart';
import 'package:social_network/presentation/blocs/admins/services/services_bloc.dart';
import 'package:social_network/presentation/blocs/admins/users/users_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/blocs/clients/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/blocs/clients/booking_service/booking_service_bloc.dart';
import 'package:social_network/presentation/blocs/clients/cart/cart_bloc.dart';
import 'package:social_network/presentation/blocs/clients/infor_contact/infor_contact_bloc.dart';
import 'package:social_network/presentation/blocs/clients/my_feed_back/my_feed_back_bloc.dart';
import 'package:social_network/presentation/blocs/clients/my_feed_back_create/my_feed_back_create_bloc.dart';
import 'package:social_network/presentation/blocs/clients/order/order_bloc.dart';
import 'package:social_network/presentation/blocs/clients/post_detail/post_detail_bloc.dart';
import 'package:social_network/presentation/blocs/clients/posts/posts_bloc.dart';
import 'package:social_network/presentation/blocs/signin/signin_cubit.dart';
import 'package:social_network/presentation/blocs/signup/signup_bloc.dart';
import 'package:social_network/presentation/blocs/user_infor/user_infor_bloc.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);

  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  sl.registerLazySingleton<FileRepository>(() => FileStoreIml());

  sl.registerLazySingleton<CategoryRemote>(() => CategoryRemote());
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryIml(sl.call()));
  sl.registerLazySingleton<CategoryBloc>(
      () => CategoryBloc(categoryRepository: sl.call()));

  sl.registerLazySingleton<ProductRemote>(() => ProductRemote());
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryIml(sl.call()));
  sl.registerLazySingleton<OrderRemote>(() => OrderRemote());
  sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryIml(sl.call()));

  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl());
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(sl.call()));

  sl.registerLazySingleton<UserRemote>(() => UserRemote());
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryIml(sl.call()));
  sl.registerFactory<UsersBloc>(() => UsersBloc(sl.call()));

  sl.registerLazySingleton<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSourceImpl());
  sl.registerLazySingleton<ServiceRepository>(
      () => ServiceRepositoryImpl(sl.call()));
  sl.registerFactory<ServicesBloc>(() => ServicesBloc(sl.call()));
  sl.registerFactory<ServiceFormBloc>(
      () => ServiceFormBloc(sl.call(), sl.call()));

  // service
  sl.registerLazySingleton<BookingServiceRemoteDataSource>(
      () => BookingServiceRemoteDataSourceImpl());
  sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryIml(sl.call()));

  // feed back
  sl.registerLazySingleton<FeedBackRemoteDataSource>(
      () => FeedBackRemoteDataSourceImpl());
  sl.registerLazySingleton<FeedBackRepository>(
      () => FeedBackRepositoryImpl(sl.call()));

  _initAuth();
  _initClient();
  _initAdmin();
}

void _initAdmin() {
  sl.registerFactory<ManageProductBloc>(() => ManageProductBloc(
      productRepository: sl.call(), fileRepository: sl.call()));

  //post
  sl.registerFactory<PostsBloc>(() => PostsBloc(sl.call()));
  sl.registerFactory<PostFormBloc>(
    () => PostFormBloc(postRepository: sl.call(), fileRepository: sl.call()),
  );
  sl.registerFactory<PostDetailBloc>(
    () => PostDetailBloc(sl.call(), sl.call()),
  );
  // feed back
  sl.registerFactory<FeedBacksBloc>(() => FeedBacksBloc(sl.call()));
  sl.registerFactory<FeedBackDetailBloc>(
    () => FeedBackDetailBloc(sl.call()),
  );

  // manage user
  sl.registerFactory<EmployeeRemoteDataSource>(
      () => EmployeeRemoteDataSourceImpl());
  sl.registerFactory<EmployeeRepository>(
      () => EmployeeRepositoryImpl(sl.call()));
  sl.registerFactory<EmployeesBloc>(() => EmployeesBloc(sl.call()));
  sl.registerFactory<EmployeeFormBloc>(() => EmployeeFormBloc(sl.call()));

  // booking service
  sl.registerFactory<ServiceBookingBloc>(() => ServiceBookingBloc(sl.call()));
}

void _initClient() {
  sl.registerLazySingleton<InforContactRemote>(() => InforContactRemote());
  sl.registerLazySingleton<InforContactRepository>(
      () => InforContactRepositoryIml(inforContactRemote: sl.call()));
  sl.registerLazySingleton<CartRemote>(() => CartRemote());
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryIml(sl.call()));

  sl.registerFactory<CartBloc>(() => CartBloc(cartRepository: sl.call()));
  sl.registerFactory<InforContactBloc>(() => InforContactBloc(sl.call()));
  sl.registerFactory<OrderBloc>(() => OrderBloc(sl.call()));

  // post
  sl.registerFactory<PostsClientBloc>(() => PostsClientBloc(sl.call()));
  sl.registerFactory<PostViewDetailBloc>(
      () => PostViewDetailBloc(sl.call(), sl.call()));

  // service
  sl.registerFactory<BookingServiceBloc>(() => BookingServiceBloc(sl.call()));
  sl.registerFactory<BookingServiceCreateBloc>(
      () => BookingServiceCreateBloc(sl.call()));

  // my feed back
  sl.registerFactory<MyFeedBackBloc>(
      () => MyFeedBackBloc(sl.call(), sl.call()));
  sl.registerFactory<MyFeedBackCreateBloc>(
      () => MyFeedBackCreateBloc(sl.call(), sl.call()));
}

void _initAuth() {
  sl.registerLazySingleton<AuthFirebase>(() => AuthFirebase());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryIml(sl.call()));
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(authRepository: sl.call()));
  sl.registerLazySingleton<SigninCubit>(() => SigninCubit());
  sl.registerSingleton<SignupBloc>(SignupBloc());

  sl.registerFactory<UserInforBloc>(() => UserInforBloc(sl.call(), sl.call()));
}

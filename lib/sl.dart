import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_network/data/datasources/ecom/category_repository.dart';
import 'package:social_network/data/datasources/ecom/post_remote.dart';
import 'package:social_network/data/datasources/ecom/product_repository.dart';
import 'package:social_network/data/datasources/file_repository.dart';
import 'package:social_network/data/repository/ecom/category_repository.dart';
import 'package:social_network/data/repository/ecom/product_repository.dart';
import 'package:social_network/data/repository/post/post_repository.dart';
import 'package:social_network/domain/repository/ecom/category_repository.dart';
import 'package:social_network/domain/repository/ecom/product_repository.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';
import 'package:social_network/presentation/blocs/admins/category/category_bloc.dart';
import 'package:social_network/presentation/blocs/admins/post_create/post_create_bloc.dart';
import 'package:social_network/presentation/blocs/admins/posts/posts_bloc.dart';
import 'package:social_network/presentation/blocs/admins/products/product_bloc.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/blocs/clients/cart/cart_bloc.dart';
import 'package:social_network/presentation/blocs/clients/infor_contact/infor_contact_bloc.dart';
import 'package:social_network/presentation/blocs/clients/order/order_bloc.dart';
import 'package:social_network/presentation/blocs/sigin/signin_cubit.dart';
import 'package:social_network/presentation/blocs/signup/signup_bloc.dart';
import 'package:social_network/data/datasources/ecom/cart_remote.dart';
import 'package:social_network/data/datasources/ecom/infor_contact_remote.dart';
import 'package:social_network/data/datasources/ecom/order_remote.dart';
import 'package:social_network/data/datasources/auth_remote.dart';
import 'package:social_network/data/repository/auth_repository.dart';
import 'package:social_network/data/repository/ecom/cart_repository.dart';
import 'package:social_network/data/repository/ecom/infor_contact_repository.dart';
import 'package:social_network/data/repository/ecom/order_repository.dart';
import 'package:social_network/domain/repository/auth_repository.dart';
import 'package:social_network/domain/repository/ecom/cart_repository.dart';
import 'package:social_network/domain/repository/ecom/infor_contact_repository.dart';
import 'package:social_network/domain/repository/ecom/order_repository.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerSingleton<FirebaseAuth>(auth);
  sl.registerSingleton<FirebaseFirestore>(fireStore);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  sl.registerLazySingleton<FileRepository>(() => FileRepositoryIml());

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
  sl.registerFactory<PostsBloc>(() => PostsBloc(sl.call()));
  sl.registerFactory<PostCreateBloc>(
    () => PostCreateBloc(postRepository: sl.call(), fileRepository: sl.call()),
  );

  _initAuth();
  _initClient();
  _initAdmin();
}

void _initAdmin() {
  sl.registerFactory<ManageProductBloc>(() => ManageProductBloc(
      productRepository: sl.call(), fileRepository: sl.call()));
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
}

void _initAuth() {
  sl.registerLazySingleton<AuthFirebase>(() => AuthFirebase());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryIml(sl.call()));
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(authRepository: sl.call()));
  sl.registerLazySingleton<SigninCubit>(() => SigninCubit());
  sl.registerSingleton<SignupBloc>(SignupBloc());
}

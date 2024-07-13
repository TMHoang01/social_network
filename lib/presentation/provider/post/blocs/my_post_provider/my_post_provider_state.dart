part of 'my_post_provider_bloc.dart';

enum MyPostProviderStatus { initial, loading, loaded, error }

class MyPostProviderState extends Equatable {
  final MyPostProviderStatus status;
  final List<PostModel> list;
  final String? message;

  const MyPostProviderState(
      {this.status = MyPostProviderStatus.initial,
      this.list = const [],
      this.message});

  @override
  List<Object?> get props => [status, list, message];

  MyPostProviderState copyWith(
      {MyPostProviderStatus? status, List<PostModel>? list, String? message}) {
    return MyPostProviderState(
        list: list ?? this.list,
        message: message,
        status: status ?? this.status);
  }
}

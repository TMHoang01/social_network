part of 'post_detail_bloc.dart';

sealed class PostDetailState extends Equatable {
  const PostDetailState();
  
  @override
  List<Object> get props => [];
}

final class PostDetailInitial extends PostDetailState {}

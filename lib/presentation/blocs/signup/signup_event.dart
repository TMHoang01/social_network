part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

final class SignupSubmitted extends SignupEvent {
  final String email;
  final String password;

  const SignupSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

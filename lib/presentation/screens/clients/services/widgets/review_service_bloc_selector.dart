import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/clients/service_detail/service_detail_bloc.dart';

class ServiceDetailBlocSelector<T> extends StatelessWidget {
  final T Function(ServiceDetailState) selector;
  final Widget Function(BuildContext, T) builder;

  const ServiceDetailBlocSelector({
    Key? key,
    required this.selector,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ServiceDetailBloc, ServiceDetailState, T>(
      selector: selector,
      builder: builder,
    );
  }
}

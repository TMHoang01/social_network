import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/domain/repository/service/service_repository.dart';
import 'package:social_network/utils/utils.dart';

part 'my_services_event.dart';
part 'my_services_state.dart';

class MyServicesBloc extends Bloc<MyServicesEvent, MyServicesState> {
  final ServiceRepository serviceRepository;
  MyServicesBloc(this.serviceRepository) : super(MyServicesInitial()) {
    on<MyServicesEvent>((event, emit) {});

    on<MyServicesStarted>(_onServicesStarted);
  }

  void _onServicesStarted(
      MyServicesStarted event, Emitter<MyServicesState> emit) async {
    emit(MyServicesLoading());
    try {
      await emit.forEach(
        serviceRepository.getAllByProvider(userId: userCurrent!.uid),
        onData: (List<ServiceModel> services) {
          if (services.isEmpty) {
            return MyServicesFailure('Danh sách dịch vụ trống');
          }
          return MyServicesLoaded(services: services);
        },
        onError: (e, stackTrace) => MyServicesFailure(e.toString()),
      );
    } catch (e) {
      emit(MyServicesFailure(e.toString()));
    }
  }
}

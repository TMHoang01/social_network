import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/domain/repository/service/service_repository.dart';
import 'package:social_network/utils/logger.dart';

part 'service_form_event.dart';
part 'service_form_state.dart';

class ServiceFormBloc extends Bloc<ServiceFormEvent, ServiceFormState> {
  final ServiceRepository serviceRepository;
  final FileRepository fileRepository;
  ServiceFormBloc(this.serviceRepository, this.fileRepository)
      : super(ServiceFormInitial()) {
    on<ServiceFormEvent>((event, emit) {});
    on<ServiceFormAddStarted>(_onServiceAddStarted);
    on<ServiceFormEditStarted>(_onServiceEditStarted);
    on<ServiceFormSubmit>(_onServiceSubmit);
  }

  void _onServiceAddStarted(
      ServiceFormAddStarted event, Emitter<ServiceFormState> emit) async {
    emit(ServiceFormAddInitial());
  }

  void _onServiceEditStarted(
      ServiceFormEditStarted event, Emitter<ServiceFormState> emit) async {
    emit(ServiceFormEditInitial());
  }

  void _onServiceSubmit(
      ServiceFormSubmit event, Emitter<ServiceFormState> emit) async {
    if (state is ServiceFormAddInitial || state is ServiceFormAddFailure) {
      emit(ServiceFormAddInProgress());
      try {
        final imageUrl = await _uploadFile(
          imagePath: event.file,
        );
        final service = event.service.copyWith(
          createdAt: DateTime.now(),
          createdBy: 'admin',
          image: imageUrl,
        );

        await serviceRepository.add(service: event.service);
        emit(ServiceFormAddSuccess());
      } catch (error) {
        emit(ServiceFormAddFailure(error.toString()));
      }
    } else if (state is ServiceFormEditInitial ||
        state is ServiceFormEditFailure) {
      emit(ServiceFormEditInProgress());
      try {
        final imageUrl = await _uploadFile(
          imagePath: event.file,
          urlOld: event.service.image,
        );
        final service = event.service.copyWith(
          updatedAt: DateTime.now(),
          updatedBy: 'admin',
          image: imageUrl,
        );
        await serviceRepository.update(service: service);
        emit(ServiceFormEditSuccess());
      } catch (error) {
        emit(ServiceFormEditFailure(error.toString()));
      }
    }
  }

  Future<String?> _uploadFile(
      {required String imagePath, String? urlOld}) async {
    try {
      if (imagePath.isEmpty) return urlOld;
      File file = File(imagePath);
      String name = DateTime.now().millisecondsSinceEpoch.toString();
      name = '$name.${imagePath.split('.').last}';

      String imageUrl = await fileRepository.uploadFile(
        file: file,
        path: 'images/services/$name',
      );
      if (urlOld != null) {
        await fileRepository.deleteFile(path: urlOld);
      }
      return imageUrl;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}

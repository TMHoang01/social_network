import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/repository/ecom/infor_contact_repository.dart';
import 'package:social_network/utils/firebase.dart';

part 'infor_contact_event.dart';
part 'infor_contact_state.dart';

class InforContactBloc extends Bloc<InforContactEvent, InforContactState> {
  final InforContactRepository _inforContactRepo;
  InforContactBloc(InforContactRepository inforContactRepository)
      : _inforContactRepo = inforContactRepository,
        super(InforContactInitial()) {
    on<GetInforContact>((event, emit) => _getInforContactToState(event, emit));

    on<SaveInforContact>((event, emit) => _addInforContactToState(event, emit));
  }

  void _getInforContactToState(
      GetInforContact event, Emitter<InforContactState> emit) async {
    try {
      final inforContact = await _inforContactRepo.findByUserId(
          userId: firebaseAuth.currentUser!.uid);
      if (inforContact == null) {
        emit(InforContactEmpty());
        return;
      }
      emit(InforContactLoaded(inforContact: inforContact));
    } catch (e) {
      emit(InforContactError(message: e.toString()));
    }
  }

  void _addInforContactToState(
      SaveInforContact event, Emitter<InforContactState> emit) async {
    try {
      InforContactModel inforContact = InforContactModel.fromJson({
        'userId': firebaseAuth.currentUser!.uid,
        'address': event.address,
        'phone': event.phone,
        'username': event.username,
      });

      if (state is InforContactEmpty) {
        inforContact =
            await _inforContactRepo.add(inforContactModel: inforContact);
      } else if (state is InforContactLoaded) {
        final id = (state as InforContactLoaded).inforContact.id;
        await _inforContactRepo.update(
            id: id ?? '', inforContactModel: inforContact);
        inforContact = inforContact.copyWith(id: id);
      }
      emit(InforContactUpdated(inforContact: inforContact));
    } catch (e) {
      emit(InforContactError(message: e.toString()));
    }
  }
}

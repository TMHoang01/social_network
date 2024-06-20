part of 'parking_bloc.dart';

enum ParkingStatus { initial, loading, modify, loaded, error }

class ParkingState extends Equatable {
  final List<ParkingLot> list;
  final String message;
  final ParkingStatus status;
  final ParkingLot? lotSelect;

  const ParkingState({
    this.list = const <ParkingLot>[],
    this.message = '',
    this.status = ParkingStatus.initial,
    this.lotSelect,
  });

  ParkingState copyWith({
    List<ParkingLot>? list,
    String? message,
    ParkingStatus? status,
    ParkingLot? lotSelect,
  }) {
    return ParkingState(
      list: list ?? this.list,
      message: message ?? this.message,
      status: status ?? this.status,
      lotSelect: lotSelect ?? this.lotSelect,
    );
  }

  ParkingState emptyLotSelect() {
    return ParkingState(
      list: list,
      message: message,
      status: status,
      lotSelect: null,
    );
  }

  bool get disableLotSelect {
    if (lotSelect == null) {
      return true;
    }
    if (lotSelect!.status == ParkingLotStatus.available ||
        lotSelect!.status == null) {
      return false;
    }
    return true;
  }

  @override
  List<Object?> get props => [list, message, status, lotSelect];
}

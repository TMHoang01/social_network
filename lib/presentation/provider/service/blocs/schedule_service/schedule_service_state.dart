part of 'schedule_service_bloc.dart';

enum ScheduleServiceStatus { initial, loading, success, failure }

class ScheduleServiceState extends Equatable {
  ScheduleServiceStatus? status;
  List<ScheduleItem>? list;
  String? error;

  ScheduleServiceState(
      {this.status = ScheduleServiceStatus.initial, this.list, this.error});

  @override
  List<Object?> get props => [status, list, error];

  ScheduleServiceState copyWith({
    ScheduleServiceStatus? status,
    List<ScheduleItem>? list,
    String? error,
  }) {
    return ScheduleServiceState(
      status: status ?? this.status,
      list: list ?? this.list,
      error: error,
    );
  }
}

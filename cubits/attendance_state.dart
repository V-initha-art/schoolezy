part of 'attendance_cubit.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  const AttendanceSuccess(this.attendanceList);

  final AttendanceList attendanceList;

  @override
  List<Object> get props => [attendanceList];
}

class LeaveSuccess extends AttendanceState {
  const LeaveSuccess();

  @override
  List<Object> get props => [];
}

class LeaveFailure extends AttendanceState {
  const LeaveFailure(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}

class AttendanceFailure extends AttendanceState {
  const AttendanceFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class AbsentCountSuccess extends AttendanceState {
  const AbsentCountSuccess(this.count);

  final int? count;

  @override
  List<Object> get props => [count!];
}

class Failure extends AttendanceState {
  const Failure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

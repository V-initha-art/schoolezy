import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admin_attendance_state.dart';

class AdminAttendanceCubit extends Cubit<AdminAttendanceState> {
  AdminAttendanceCubit() : super(AdminAttendanceInitial());
}

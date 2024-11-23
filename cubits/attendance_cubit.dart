import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user/userrepo.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this.userRepository) : super(AttendanceInitial());
  final UserRepository userRepository;

  Future<void> getAttendance(Child child, String datetime1, String datetime2,  ) async {
    emit(AttendanceLoading());
    try {
      final attendanceList = await userRepository.restApiGetAttendance(child,datetime1,datetime2);

      emit(AttendanceSuccess(attendanceList));
    } catch (e) {
 
      
      emit(AttendanceFailure(e.toString()));
    }
  }

  Future<void> postLeaveRequest(Child child, Leave leave) async {
    emit(AttendanceLoading());
    try {
      await userRepository.restApiPostLeaveRequest(child, leave);
      emit(const LeaveSuccess());
    } catch (e) {
      emit(LeaveFailure(e.toString()));
    }
  }

  Future<void> absentCalculate(
    AttendanceList attendanceList,
    DateTime currentMonth,
  ) async {
    emit(AttendanceLoading());
    try {
      final count = await userRepository.getAbsentData(
        attendanceList,
        currentMonth,
      );
      emit(AbsentCountSuccess(count));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }
}

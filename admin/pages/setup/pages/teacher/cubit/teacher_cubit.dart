import 'package:admin/adminrepo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:schoolezy/pages/admin/pages/setup/pages/employee/modal/status.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/gender.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/student_name.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/teacher/modal/employee.dart';

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  TeacherCubit(this.adminRepository) : super(TeacherInitial());
  final AdminRepository adminRepository;

  void onInstructorNameChange(String instructorname) {
    emit(
      state.copyWith(
        studentname: SelectedStudentName.dirty(instructorname),
        gender: state.gender,
        selectedstatus: state.selectedstatus,
        selectemployee: state.selectemployee,
      ),
    );
  }

  void onInstructorgenderChange(String? genderlist) {
    emit(
      state.copyWith(
        studentname: state.studentname,
        gender: Gender.dirty(genderlist.toString()),
        selectedstatus: state.selectedstatus,
        selectemployee: state.selectemployee,
      ),
    );
  }

  void onInstructorStatusChange(String? statuslist) {
    emit(
      state.copyWith(
        studentname: state.studentname,
        gender: state.gender,
        selectedstatus: SelectedStatus.dirty(statuslist.toString()),
        selectemployee: state.selectemployee,
      ),
    );
  }

  void onInstructorEmployeeChange(Employee? selectedEmployee) {
    emit(
      state.copyWith(
          studentname: state.studentname,
          gender: state.gender,
          selectedstatus: state.selectedstatus,
          selectemployee: SelectEmployee.dirty(selectedEmployee!.name!)),
    );
  }

  Future<void> onPostInstructorList() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await adminRepository.postRestApiInstructor(
        state.studentname.value,
        //  state.gender.value,
        state.selectedstatus.value,
        state.selectemployee.value,
      );
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
        ),
     
      );
        // await getTeachers();
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}

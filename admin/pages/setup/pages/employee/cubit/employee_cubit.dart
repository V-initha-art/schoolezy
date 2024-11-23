import 'package:admin/adminrepo.dart';
import 'package:bloc/bloc.dart';

import 'package:formz/formz.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/employee/modal/contactemail.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/employee/modal/dateofjoing.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/employee/modal/personalemail.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/employee/modal/teachingstaff.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/date_of_birth.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/gender.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/student_name.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit(this.adminRepository) : super(EmployeeInitial());
  final AdminRepository adminRepository;

  Future<void> getEmployee() async {
    emit(EmployeeLoading());
    try {
      final employeeView = await adminRepository.getRestApiemployeeList();
      emit(EmployeeSuccess(employeeView));
    } catch (e) {
      emit(EmployeeFailure());
    }
  }

  void onemployeeChange(String _employeename) {
    emit(
      state.copyWith(
        employeename: SelectedStudentName.dirty(_employeename),
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        dateofjoing: state.dateofjoing,
        personalemail: state.personalemail,
        contactemail: state.contactemail,
        teachingstaff: state.teachingstaff,
      ),
    );
  }

  void onDateofbirthChange(String dateofbirth) {
    emit(
      state.copyWith(
        employeename: state.employeename,
        gender: state.gender,
        dateofbirth: DateOfBirth.dirty(dateofbirth),
        dateofjoing: state.dateofjoing,
        personalemail: state.personalemail,
        contactemail: state.contactemail,
        teachingstaff: state.teachingstaff,
      ),
    );
  }

  void ongenderChange(String? genderList) {
    emit(
      state.copyWith(
        employeename: state.employeename,
        gender: Gender.dirty(genderList!),
        dateofbirth: state.dateofbirth,
        dateofjoing: state.dateofjoing,
        personalemail: state.personalemail,
        contactemail: state.contactemail,
        teachingstaff: state.teachingstaff,
      ),
    );
  }

  void onTeachingStaffChange(int teachingStaff) {
    // int? teaching
    emit(
      state.copyWith(
          employeename: state.employeename,
          gender: state.gender,
          dateofbirth: state.dateofbirth,
          dateofjoing: state.dateofjoing,
          personalemail: state.personalemail,
          contactemail: state.contactemail,
          teachingstaff: TeachingStaff.dirty(teachingStaff.toInt() as String)),
    );
  }

  void ondateofjoingChange(String dateofjoing) {
    emit(
      state.copyWith(
        employeename: state.employeename,
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        dateofjoing: DateOfJoing.dirty(dateofjoing),
        personalemail: state.personalemail,
        contactemail: state.contactemail,
        teachingstaff: state.teachingstaff,
      ),
    );
  }

  void onPersonalEmail(String personalemail) {
    emit(
      state.copyWith(
        employeename: state.employeename,
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        dateofjoing: state.dateofjoing,
        personalemail: PersonalEmail.dirty(personalemail),
        contactemail: state.contactemail,
        teachingstaff: state.teachingstaff,
      ),
    );
  }

  void onContactEmailChange(String? contectlist) {
    emit(
      state.copyWith(
        employeename: state.employeename,
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        dateofjoing: state.dateofjoing,
        personalemail: state.personalemail,
        contactemail: ContactEmail.dirty(contectlist!),
        teachingstaff: state.teachingstaff,
      ),
    );
  }

  Future<void> onPostEmployeeList(int teachingStaff) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await adminRepository.postRestApiemployeeList(
        state.employeename.value,
        state.personalemail.value,
        state.dateofbirth.value,
        state.contactemail.value,
        state.dateofjoing.value,
        state.gender.value,
        teachingStaff,
      );

      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      );
      await getEmployee();
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}

import 'dart:io' as dartio;
import 'dart:typed_data';

import 'package:admin/adminrepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/address.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/class.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/date_of_birth.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/email_id.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/gender.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/mobile_number.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/section_group.dart';
import 'package:schoolezy/pages/admin/pages/setup/pages/student/model/student_name.dart';
import 'package:user/userrepo.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  StudentCubit(this.adminRepository, this.userRepository) : super(StudentInitial());

  final AdminRepository adminRepository;
  final UserRepository userRepository;
  Future<void> uploadFile(
    Uint8List? webFile,
    dartio.File? file,
    String? fileName,
    String? doctype,
  ) async {
    emit(UploadFileLoading());
    if (webFile != null) {
      try {
        final message = await userRepository.postRestApiFile(webFile, fileName!, null, doctype.toString());
        emit(UploadFileStatus(message));
      } catch (e) {
        emit(Failure(e.toString()));
      }
    } else {
      try {
        final message = await userRepository.postRestApiFile(null, fileName!, file, doctype.toString());
        emit(UploadFileStatus(message));
      } catch (e) {
        emit(Failure(e.toString()));
      }
    }
  }

  Future<void> downloadTemplateFile() async {
    try {
      final responseBytes = await adminRepository.getRestApiTemplateFile('');
      //  emit(DownloadingFileSuccess(responseBytes));
    } catch (e) {
      emit(DownloadingFileFailure());
    }
  }

  Future<void> getStudentView() async {
    emit(StudentViewLoading());
    try {
      final StudentView = await adminRepository.getRestApiStudentList();
      emit(StudentViewsuccess(StudentView));
    } catch (e) {
      emit(StudentFailure());
    }
  }

  void onStudentNameChange(String name) {
    emit(
      state.copyWith(
        studentname: SelectedStudentName.dirty(name),
        mobilenumber: state.mobilenumber,
        eid: state.eid,
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        address: state.address,
        selectedclass: state.selectedclass,
        section: state.section,
      ),
    );
  }

  void onEmailIDChange(String email) {
    emit(
      state.copyWith(
        studentname: state.studentname,
        mobilenumber: state.mobilenumber,
        eid: SelectedEmailID.dirty(email),
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        address: state.address,
        selectedclass: state.selectedclass,
        section: state.section,
      ),
    );
  }

  void onDateOfBirthChange(String dateofbirth) {
    emit(
      state.copyWith(
        studentname: state.studentname,
        mobilenumber: state.mobilenumber,
        eid: state.eid,
        gender: state.gender,
        dateofbirth: DateOfBirth.dirty(dateofbirth),
        address: state.address,
        selectedclass: state.selectedclass,
        section: state.section,
      ),
    );
  }

  void onMobileChange(String mobilenumber) {
    emit(
      state.copyWith(
        studentname: state.studentname,
        mobilenumber: MobileNumber.dirty(mobilenumber),
        eid: state.eid,
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        address: state.address,
        selectedclass: state.selectedclass,
        section: state.section,
      ),
    );
  }

  void onGenderChange(String? selectedgender) {
    emit(
      state.copyWith(
        studentname: state.studentname,
        mobilenumber: state.mobilenumber,
        eid: state.eid,
        gender: Gender.dirty(selectedgender!),
        dateofbirth: state.dateofbirth,
        address: state.address,
        selectedclass: state.selectedclass,
        section: state.section,
      ),
    );
  }

  void onAddressChange(String address) {
    emit(
      state.copyWith(
        studentname: state.studentname,
        mobilenumber: state.mobilenumber,
        eid: state.eid,
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        address: Address.dirty(address),
        selectedclass: state.selectedclass,
        section: state.section,
      ),
    );
  }

  void onclassChange(NameOnly? selectedProgram) {
    emit(
      state.copyWith(
        studentname: state.studentname,
        mobilenumber: state.mobilenumber,
        eid: state.eid,
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        address: state.address,
        selectedclass: SelectedClass.dirty(selectedProgram!.name.toString()),
        section: state.section,
      ),
    );
  }

  void onsectionChange(NameOnly? selectedSection) {
    emit(
      state.copyWith(
        studentname: state.studentname,
        mobilenumber: state.mobilenumber,
        eid: state.eid,
        gender: state.gender,
        dateofbirth: state.dateofbirth,
        address: state.address,
        selectedclass: state.selectedclass,
        section: SectionGroup.dirty(selectedSection!.name.toString()),
      ),
    );
  }

  // Future<void> onPostStudentList() async {
  //   emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

  //   try {
  //     await adminRepository.postRestApiStudent(
  //       state.studentname.value,
  //       state.dateofbirth.value,
  //       state.eid.value,
  //       state.mobilenumber.value,
  //       state.gender.value,
  //       state.address.value,
  //       state.selectedclass.value,
  //       state.section.value,
  //     );
  //     emit(
  //       state.copyWith(
  //         status: FormzSubmissionStatus.success,
  //       ),
  //     );
  //     await getStudentView();
  //   } catch (_) {
  //     emit(state.copyWith(status: FormzSubmissionStatus.failure));
  //   }
  // }

  // Future<void> downloadFile(
  //   String fileName,
  // ) async {
  //   emit(DownloadingFile());
  //   try {
  //     await adminRepository.downloadAFileRestApi(fileName);
  //     emit(DownloadingFileSuccess());
  //   } catch (e) {
  //     emit(DownloadingFileFailure());
  //   }
  // }
}

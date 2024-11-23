part of 'student_cubit.dart';

// abstract class StudentState {
//   const StudentState();
// }

class StudentState with FormzMixin {
  const StudentState({
    this.status = FormzSubmissionStatus.initial,
    this.studentname = const SelectedStudentName.pure(),
    this.mobilenumber = const MobileNumber.pure(),
    this.eid = const SelectedEmailID.pure(),
    this.gender = const Gender.pure(),
    this.dateofbirth = const DateOfBirth.pure(),
    this.address = const Address.pure(),
    this.selectedclass = const SelectedClass.pure(),
    this.section = const SectionGroup.pure(),
  });

  final FormzSubmissionStatus status;

  final SelectedStudentName studentname;
  final MobileNumber mobilenumber;
  final SelectedEmailID eid;
  final Gender gender;
  final DateOfBirth dateofbirth;
  final Address address;
  final SelectedClass selectedclass;
  final SectionGroup section;

  StudentState copyWith({
    FormzSubmissionStatus? status,
    SelectedStudentName? studentname,
    MobileNumber? mobilenumber,
    SelectedEmailID? eid,
    Gender? gender,
    DateOfBirth? dateofbirth,
    Address? address,
    SelectedClass? selectedclass,
    SectionGroup? section,
  }) {
    return StudentState(
        status: status ?? this.status,
        studentname: studentname ?? this.studentname,
        mobilenumber: mobilenumber ?? this.mobilenumber,
        eid: eid ?? this.eid,
        gender: gender ?? this.gender,
        dateofbirth: dateofbirth ?? this.dateofbirth,
        address: address ?? this.address,
        selectedclass: selectedclass ?? this.selectedclass,
        section: section ?? this.section);
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [studentname, mobilenumber, eid, gender, dateofbirth, address];
}

class StudentInitial extends StudentState {}

class UploadFileLoading extends StudentState {}

class UploadFileStatus extends StudentState {
  const UploadFileStatus(this.message);

  final UploadFile message;
}

class Failure extends StudentState {
  const Failure(this.message);

  final String? message;
}

class DownloadingFile extends StudentState {}

class DownloadingFileSuccess extends StudentState {
  DownloadingFileSuccess(this.uint8list);

  final Uint8List? uint8list;
}

class DownloadingFileFailure extends StudentState {}

class StudentViewLoading extends StudentState {}

class StudentViewsuccess extends StudentState {
  StudentViewsuccess(this.StudentView);
  final Students? StudentView;
}

class StudentFailure extends StudentState {}

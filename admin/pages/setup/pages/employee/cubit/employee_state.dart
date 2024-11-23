part of 'employee_cubit.dart';

class EmployeeState with FormzMixin {
  const EmployeeState({
    this.status = FormzSubmissionStatus.initial,
    this.employeename = const SelectedStudentName.pure(),
    this.gender = const Gender.pure(),
    this.dateofbirth = const DateOfBirth.pure(),
    this.dateofjoing = const DateOfJoing.pure(),
    this.personalemail = const PersonalEmail.pure(),
    this.contactemail = const ContactEmail.pure(),
    this.teachingstaff = const TeachingStaff.pure(),
  });

  final FormzSubmissionStatus status;

  final SelectedStudentName employeename;
  final Gender gender;
  final DateOfBirth dateofbirth;
  final DateOfJoing dateofjoing;
  final PersonalEmail personalemail;
  final ContactEmail contactemail;
  final TeachingStaff teachingstaff;

  EmployeeState copyWith({
    FormzSubmissionStatus? status,
    SelectedStudentName? employeename,
    Gender? gender,
    DateOfBirth? dateofbirth,
    DateOfJoing? dateofjoing,
    PersonalEmail? personalemail,
    ContactEmail? contactemail,
    TeachingStaff? teachingstaff,
  }) {
    return EmployeeState(
      status: status ?? this.status,
      employeename: employeename ?? this.employeename,
      gender: gender ?? this.gender,
      dateofbirth: dateofbirth ?? this.dateofbirth,
      dateofjoing: dateofjoing ?? this.dateofjoing,
      personalemail: personalemail ?? this.personalemail,
      contactemail: contactemail ?? this.contactemail,
      teachingstaff: teachingstaff ?? this.teachingstaff,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [employeename, gender, dateofbirth, personalemail, dateofjoing, contactemail];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  const EmployeeSuccess(this.employees);
  final Employees? employees;
}

class EmployeeFailure extends EmployeeState {}

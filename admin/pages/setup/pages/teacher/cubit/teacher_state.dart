part of 'teacher_cubit.dart';

class TeacherState with FormzMixin {
  const TeacherState({
    this.status = FormzSubmissionStatus.initial,
    this.studentname = const SelectedStudentName.pure(),
     
    this.gender = const Gender.pure(),
    this.selectedstatus = const SelectedStatus.pure(),
    this.selectemployee = const SelectEmployee.pure(),

  });

  final FormzSubmissionStatus status;

  final SelectedStudentName studentname;
  final Gender gender;
  final SelectedStatus selectedstatus;
  final SelectEmployee selectemployee;

 


  TeacherState copyWith({
    FormzSubmissionStatus? status,
    SelectedStudentName? studentname,
    Gender?gender,
    SelectedStatus? selectedstatus,
    SelectEmployee? selectemployee,



    
  }) {
    return TeacherState(
     status: status ?? this.status,
     studentname: studentname ?? this.studentname,
     gender: gender?? this.gender,
     selectedstatus: selectedstatus?? this.selectedstatus,
     selectemployee:selectemployee?? this.selectemployee,
   
   
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [studentname,gender,selectedstatus];
}

class TeacherInitial extends TeacherState {}

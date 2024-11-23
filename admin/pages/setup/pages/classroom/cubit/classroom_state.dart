// ignore_for_file: override_on_non_overriding_member

part of 'classroom_cubit.dart';

class ClassroomState with FormzMixin {
  ClassroomState({
    String? program,
    String? section,
    List<Map<String, Map<String, String>>>? programSectionTeacher,
    this.status = FormzSubmissionStatus.initial,
  })  : program = program ?? '',
        section = section ?? '',
        programSectionTeacher = programSectionTeacher ?? [];

  final String? program;
  final String? section;
  final List<Map<String, Map<String, String>>>? programSectionTeacher;
  final FormzSubmissionStatus status;

  ClassroomState copyWith({
    String? program,
    String? section,
    List<Map<String, Map<String, String>>>? programSectionTeacher,
    FormzSubmissionStatus? status,
  }) {
    return ClassroomState(
      programSectionTeacher:
          programSectionTeacher ?? this.programSectionTeacher,
      program: program ?? this.program,
      section: section ?? this.section,
      status: status ?? this.status,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [];
}

class ClassRoomPost extends ClassroomState {}

class ClassroomInitial extends ClassroomState {}

class Loading extends ClassroomState {}

class ClassroomSection extends ClassroomState {
  ClassroomSection(this.classSectionCreated);

  final List<String> classSectionCreated;

  @override
  List<Object> get props => [classSectionCreated];
}

class ClassroomAddSection extends ClassroomState {
  ClassroomAddSection(this.classSectionCreated);

  final String classSectionCreated;

  @override
  List<Object> get props => [classSectionCreated];
}

class CoursesLoading extends ClassroomState {}

class CoursesSuccess extends ClassroomState {
  CoursesSuccess(this.courses);

  final List<String>? courses;
}

class CoursesFailure extends ClassroomState {
  CoursesFailure();
}

class StudentGroupLoading extends ClassroomState {}

class StudentGroupSuccess extends ClassroomState {
  StudentGroupSuccess(this.studentGroup);

  final List<StudentGroup>? studentGroup;
}

class TeachersLoading extends ClassroomState {}

class ClassLoading extends ClassroomState {}

class ClassRoomPostTrigger extends ClassroomState {}

class ClassPostLoading extends ClassroomState {}

class ClassPostSuccess extends ClassroomState {}

class ClassSuccess extends ClassroomState {}

class ProgramLoading extends ClassroomState {}

class ProgramSucess extends ClassroomState {
  ProgramSucess(this.classes);

  final List<String>? classes;
}

class ProgramFailure extends ClassroomState {}

class ClassroomAddTeachers extends ClassroomState {
  ClassroomAddTeachers(this.teachers);

  final Teachers? teachers;

  @override
  List<Object> get props => [teachers!];
}
class ClassroomFailureTeachers extends ClassroomState {}

class Failure extends ClassroomState {
  Failure(this.failure);

  final String failure;

  @override
  List<Object> get props => [failure];
}

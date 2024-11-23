// ignore_for_file: unused_local_variable

import 'package:admin/adminrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'classroom_state.dart';

class ClassroomCubit extends Cubit<ClassroomState> {
  ClassroomCubit(
    this.adminRepository,
  ) : super(ClassroomInitial());

  AdminRepository adminRepository;

  Future<void> createClass(String classNumber) async {
    emit(Loading());

    try {
      final classSections =
          await adminRepository.createRepoClassSection(classNumber);
      emit(ClassroomSection(classSections));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  Future<void> addMoreClassSection(String classSectionNumber) async {
    emit(Loading());

    try {
      final addClassSection =
          await adminRepository.addRepoMoreSection(classSectionNumber);
      emit(ClassroomAddSection(addClassSection));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  Future<void> getTeachers() async {
    emit(TeachersLoading());
    try {
      final teachers = await adminRepository.getRestApiTeachers();
      emit(ClassroomAddTeachers(teachers));
    } catch (e) {
      emit(ClassroomFailureTeachers());
    }
  }

  Future<void> getCourses() async {
    emit(CoursesLoading());
    try {
      final courses = await adminRepository.getRestApiCourses();
      emit(CoursesSuccess(courses));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  Future<void> getClass() async {
    emit(ProgramLoading());
    try {
      final classes = await adminRepository.getRestApiProgram();
      emit(ProgramSucess(classes));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  Future<void> getStudentGroup() async {
    emit(StudentGroupLoading());
    try {
      final studentGroup = await adminRepository.getRestApiStudentGroup();
      emit(StudentGroupSuccess(studentGroup));
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }

  void triggerProgramSectionTeacher() {
    emit(ClassRoomPostTrigger());
  }

  Future<void> postClassAndSectionWithTeacher(
      List<Map<String, Map<String, String>>>? programSectionTeacher) async {
    emit(ClassLoading());
    try {
      final postSectionStandardTeacher = await adminRepository
          .postRestApiStandardClassTeacher(programSectionTeacher);
      emit(ClassSuccess());
    } catch (e) {
      emit(Failure(e.toString()));
    }
  }
}

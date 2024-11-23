import 'dart:io' as dartio;
import 'dart:typed_data';

import 'package:admin/adminrepo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/userrepo.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this.adminRepository, this.userRepository) : super(AdminInitial());
  final AdminRepository adminRepository;
  final UserRepository userRepository;

  Future<FilePickerResult?> pickImportDataFile() async {
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx', 'csv'],
    );
    return null;
  }

  Future<void> pickSchoolImage() async {
    emit(SchoolImageLoading());
    try {
      final filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],
      );
      if (filePickerResult != null) {
        emit(SchoolImageSucess(filePickerResult));
      } else {
        emit(const AdminFailure('no school image'));
      }
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> pickLogoImage() async {
    emit(LogoImageLoading());
    try {
      final filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg'],
      );
      print('${FileType.custom}........');
      if (filePickerResult != null) {
        emit(LogoImageSucess(filePickerResult));
      } else {
        emit(const AdminFailure('no school logo'));
      }
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> getSchoolList() async {
    emit(SchoolListLoading());

    try {
      final schools = await adminRepository.getRestApiSchoolList();
      emit(SchoolSuccess(schools));
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }

    // if (state.status.isValidated) {
    //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
    //   try {
    //     final parent = await _authenticationRepository.restApilogIn(
    //       mobileOremail: state.mobileNo.value,
    //       password: state.password.value,
    //     );
    //     await _localStorageRepository.insertRecords(parent);

    //     emit(
    //       state.copyWith(
    //         status: FormzStatus.submissionSuccess,
    //         user: parent,
    //       ),
    //     );
    //   } catch (_) {
    //     emit(state.copyWith(status: FormzStatus.submissionAdminFailure));
    //   }
    // }
  }

  // Future<void> getStudentLogList() async {
  //   emit(EventLoading());
  //   try {
  //     final studentLogs = await adminRepository.getRestApiStudentLogList();
  //     emit(StudentLogSuccess(studentLogs));
  //   } catch (e) {
  //     emit(AdminFailure(e.toString()));
  //   }
  // }

  // Future<void> getFeeCategorys() async {
  //   emit(FeeCategorysLoading());
  //   try {
  //     final feeCategorys = await adminRepository.getRestApiFeeCategorys();
  //     emit(FeeCategorysSuccess(feeCategorys));
  //   } catch (e) {
  //     emit(AdminFailure(e.toString()));
  //   }
  // }

  Future<void> getAcademicTerms() async {
    emit(AcademicTermsLoading());
    try {
      final academicTerms = await adminRepository.getRestApiAcademicTerms();
      emit(AcademicTermsSuccess(academicTerms));
    } catch (e) {
      emit(AcademicTermsAdminFailure());
    }
  }

  Future<void> getAccounts(String company) async {
    emit(AccountssLoading());
    try {
      final accounts = await adminRepository.getRestApiAccounts(company);
      emit(AccountssSuccess(accounts));
    } catch (e) {
      emit(AccountssAdminFailure());
    }
  }

  Future<void> uploadFile(Uint8List? webFile, dartio.File? file, String? fileName, String? doctype) async {
    emit(UploadFileLoading());
    if (webFile != null) {
      try {
        final importLogStatus = await userRepository.postRestApiFile(webFile, fileName!, null, doctype.toString());
        emit(UploadFileSuccess(importLogStatus));
      } catch (e) {
        emit(AdminFailure(e.toString()));
      }
    } else {
      try {
        final message = await userRepository.postRestApiFile(null, fileName!, file, doctype.toString());
        emit(UploadFileSuccess(message));
      } catch (e) {
        emit(AdminFailure(e.toString()));
      }
    }
  }

  Future<void> postDataImport(
    Uint8List? file,
    String? fileName,
    String importDataType,
  ) async {
    switch (importDataType) {
      case 'Course':
        emit(CourseDataImportLoading());
        break;
      case 'Program':
        emit(ProgramDataImportLoading());
        break;
      case 'Student Group':
        emit(ProgramSectionDataImportLoading());
        break;
      case 'Student':
        emit(StudentDataImportLoading());
        break;
      case 'Program Enrollment':
        emit(ProgramEnrolmentImportLoading());
        break;
      case 'Employee':
        emit(EmployeesImportLoading());
        break;
      default:
    }
    try {
      final importLogStatus = await userRepository.postRestApiDataImport(
        file,
        fileName,
        null,
        importDataType,
      );
      switch (importDataType) {
        case 'Course':
          emit(CourseDataImportSuccess(importLogStatus));
          break;
        case 'Program':
          emit(ProgramDataImportSuccess(importLogStatus));
          break;
        case 'Student Group':
          emit(ProgramSectionDataImportSuccess(importLogStatus));
          break;
        case 'Student':
          emit(StudentDataImportSuccess(importLogStatus));
          break;
        case 'Program Enrollment':
          emit(ProgramEnrolmentImportSuccess(importLogStatus));
          break;
        case 'Employee':
          emit(EmployeesImportSuccess(importLogStatus));
          break;
        default:
      }
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> getCourse() async {
    emit(CourseImportCheck());
    try {
      final importCourse = await adminRepository.getCourseRestApi();
      emit(CourseImportSuccess(importCourse));
    } catch (e) {
      AdminFailure(e.toString());
    }
  }

  Future<void> getPrograms() async {
    emit(ProgramImportCheck());
    try {
      final importPrograms = await adminRepository.getRestApiPrograms();
      emit(ProgramImportSuccess(importPrograms));
    } catch (e) {
      ProgramImportAdminFailure();
    }
  }

  // Future<void> getSubjects() async {
  //   emit(SubjectsLoading());
  //   try {
  //     final subjects = await adminRepository.getRestApiCourses();
  //     emit(SubjectsLoadingSuccess(subjects));
  //   } catch (e) {
  //     SubjectsLoadingAdminFailure();
  //   }
  // }

  Future<void> getCounts() async {
    emit(CountOnboardLoading());
    try {
      final counts = await adminRepository.getCountsRestApi();
      emit(CountOnboardSuccess(counts));
    } catch (e) {
      AdminFailure(e.toString());
    }
  }

  Future<void> getSection() async {
    emit(SectionImportLoading());
    try {
      final importSection = await adminRepository.getRestApiSection();
      emit(SectionImportSuccess(importSection));
    } catch (e) {
      SectionImportAdminFailure();
    }
  }

  Future<void> companyAcadmicYearUpdate(
    String school,
    String year,
  ) async {
    emit(AcadamicYearUpdateLoading());
    try {
      await adminRepository.putRestApiCompanyAcadamicYear(
        school,
        year,
      );
      emit(AcadamicYearUpdateSuccess());
    } catch (e) {
      AdminFailure(e.toString());
    }
  }

  Future<void> getStudent() async {
    emit(StudentImportLoading());

    try {
      final importStudent = await adminRepository.getRestApiStudent();
      emit(StudentImportSuccess(importStudent));
    } catch (e) {
      AdminFailure(e.toString());
    }
  }

  Future<void> getProgramEnrolment() async {
    emit(ProgramEnrolmentPostLoading());

    try {
      final programenrolment = await adminRepository.getRestApiProgramEnrolment();
      emit(ProgramEnrolmentPostSuccess(programenrolment));
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  // Future<void> getProgramEnrolment() async {
  //   emit(ProgramEnrolmentPostLoading());

  //   try {
  //     final programenrolment =
  //         await adminRepository.getRestApiProgramEnrolment();
  //     emit(ProgramEnrolmentPostSuccess(programenrolment));
  //   } catch (e) {
  //     emit(AdminFailure(e.toString()));
  //   }
  // }

  Future<void> postProgramEnrolment(
    String student,
    String program,
    String enrollment_date,
    String academic_year,
  ) async {
    emit(PostProgramEnrollementLoading());
    try {
      await adminRepository.postRestApiProgramEnrolment(
        student,
        program,
        enrollment_date,
        academic_year,
      );
      emit(PostProgramEnrollementSuccess());
    } catch (e) {
      emit(PostProgramEnrolmentAdminFailure());
    }
  }

  Future<void> postFees(
    String student,
    String institution,
    String posting_date,
    String due_date,
    String academic_year,
    String program_enrollment,
    String fee_structure,
    List<FeeComponentPost> components,
  ) async {
    emit(PostFeesLoading());
    try {
      await adminRepository.postRestApiFees(
        student,
        institution,
        posting_date,
        due_date,
        academic_year,
        program_enrollment,
        fee_structure,
        components,
      );
      emit(PostFeesSuccess());
    } catch (e) {
      emit(PostFeesAdminFailure());
    }
  }
}




  //   if (webFile != null) {
  //     try {
        
  //   } else {
  //     try {
  //       final message = await userRepository.postRestApiFile(
  //         null,
  //         fileName,
  //         file,
  //       );
  //       emit(UploadFileSuccess(message));
  //     } catch (e) {
  //       emit(AdminFailure(e.toString()));
  //     }
  //   }
  // }

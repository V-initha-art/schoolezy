part of 'admin_cubit.dart';

abstract class AdminState {
  const AdminState();
}

class AdminInitial extends AdminState {}

class GetSchoolList extends AdminState {}

class SchoolListLoading extends AdminState {}

class SchoolImageLoading extends AdminState {}

class SchoolImageSucess extends AdminState {
  const SchoolImageSucess(this.filePickerResult);

  final FilePickerResult? filePickerResult;
}

class LogoImageLoading extends AdminState {}

class LogoImageSucess extends AdminState {
  const LogoImageSucess(this.filePickerResult);

  final FilePickerResult? filePickerResult;
}

class UploadFileLoading extends AdminState {}

class DataImportLoading extends AdminState {}

class DataImportSuccess extends AdminState {
  const DataImportSuccess(this.importLogs);

  final ImportLogs? importLogs;
}

class CourseDataImportLoading extends AdminState {}

class CourseDataImportSuccess extends AdminState {
  const CourseDataImportSuccess(this.importLogs);

  final ImportLogs? importLogs;
}

class ProgramDataImportLoading extends AdminState {}

class ProgramDataImportSuccess extends AdminState {
  const ProgramDataImportSuccess(this.importLogs);

  final ImportLogs? importLogs;
}

class ProgramImportAdminFailure extends AdminState {}

class ProgramSectionDataImportLoading extends AdminState {}

class ProgramSectionDataImportSuccess extends AdminState {
  const ProgramSectionDataImportSuccess(this.importLogs);

  final ImportLogs? importLogs;
}

class StudentDataImportLoading extends AdminState {}

class StudentDataImportSuccess extends AdminState {
  const StudentDataImportSuccess(this.importLogs);

  final ImportLogs? importLogs;
}

class ProgramEnrolmentImportLoading extends AdminState {}

class ProgramEnrolmentImportSuccess extends AdminState {
  const ProgramEnrolmentImportSuccess(this.importLogs);

  final ImportLogs? importLogs;
}

class DataImportAdminFailure extends AdminState {
  const DataImportAdminFailure(this.importLogs);

  final ImportLogs? importLogs;
}

class UploadFileSuccess extends AdminState {
  const UploadFileSuccess(this.uploadFile);

  final UploadFile? uploadFile;
}

class FeeCategorysLoading extends AdminState {}

class AcademicTermsLoading extends AdminState {}

class AcademicTermsAdminFailure extends AdminState {}

class AcademicTermsSuccess extends AdminState {
  AcademicTermsSuccess(this.academicTerms);

  final AcademicTerms? academicTerms;
}

class AccountssLoading extends AdminState {}

class AccountssSuccess extends AdminState {
  const AccountssSuccess(this.names);

  final Names? names;
}

class AccountssAdminFailure extends AdminState {}

// class FeeCategorysSuccess extends AdminState {
//   const FeeCategorysSuccess(this.feeCategorys);

//   final FeeCategorys? feeCategorys;
// }

class SchoolSuccess extends AdminState {
  const SchoolSuccess(this.schools);

  final Schools? schools;
}

class AdminFailure extends AdminState {
  const AdminFailure(this.message);

  final String message;
}

class StudentLogSuccess extends AdminState {
  const StudentLogSuccess(this.studentLogs);

  final StudentLogs? studentLogs;
}

class CourseImportCheck extends AdminState {}

class CourseImportSuccess extends AdminState {
  CourseImportSuccess(this.courses);

  final List<Course>? courses;
}

class ProgramImportCheck extends AdminState {}

// class ProgramsLoading extends AdminState {}

//class ProgramsAdminFailure extends AdminState {}

// class ProgramsSuccess extends AdminState {
//   ProgramsSuccess(this.programs);
//   final List<Program>? programs;
// }

class ProgramImportSuccess extends AdminState {
  ProgramImportSuccess(this.programs);

  final List<NameOnly>? programs;
}

class EmployeesImportLoading extends AdminState {}

class EmployeesImportSuccess extends AdminState {
  EmployeesImportSuccess(this.importLogs);

  final ImportLogs? importLogs;
}
class EmployeesImportFailure extends AdminState {}

class CountOnboardLoading extends AdminState {}

class CountOnboardSuccess extends AdminState {
  CountOnboardSuccess(this.countOnboard);

  final CountOnboard? countOnboard;
}

class SectionImportLoading extends AdminState {}

class SectionImportFailure extends AdminState {}

class SectionImportSuccess extends AdminState {
  SectionImportSuccess(this.section);
  final List<NameOnly>? section;
}

class SectionImportAdminFailure extends AdminState {}

class StudentImportLoading extends AdminState {}

class StudentImportSuccess extends AdminState {
  StudentImportSuccess(this.student);
  final List<NameOnly>? student;
}

class AcadamicYearUpdateLoading extends AdminState {}

class AcadamicYearUpdateSuccess extends AdminState {}

class AcadamicYearUpdateAdminFailure extends AdminState {}

class ProgramEnrolmentPostLoading extends AdminState {}

class ProgramEnrolmentPostSuccess extends AdminState {
  ProgramEnrolmentPostSuccess(this.programenrolment);
  final List<ProgramEnrollementPost>? programenrolment;
}

class PostProgramEnrollementLoading extends AdminState {}

class PostProgramEnrollementSuccess extends AdminState {}

class PostProgramEnrolmentAdminFailure extends AdminState {}

class PostFeesLoading extends AdminState {}

class PostFeesSuccess extends AdminState {}

class PostFeesAdminFailure extends AdminState {}
// class SubjectsLoading extends AdminState {}

// class SubjectsLoadingSuccess extends AdminState {
//   SubjectsLoadingSuccess(this.subjects);

//   final List<NameOnly>? subjects;
// }

// class SubjectsLoadingAdminFailure extends AdminState {}

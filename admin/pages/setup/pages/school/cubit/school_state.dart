part of 'school_cubit.dart';

// class SchoolState with FormzMixin {
//   SchoolState({
//     NameOnly? schoolName,
//     NoOnly? affiliationNo,
//     NoOnly? schoolBuildingNo,
//     NameOnly? boardName,
//     NameOnly? schoolStreetName,
//     NameOnly? schoolAreaName,
//     NameOnly? schoolStateName,
//     NoOnly? pinCodeNo,
//     NoOnly? contactNo,
//     LatLngOnly? latLngSchool,
//     this.status = FormzSubmissionStatus.initial,
//   })  : schoolName = schoolName ?? NameOnly.pure(),
//         affiliationNo = affiliationNo ?? NoOnly.pure(),
//         schoolBuildingNo = schoolBuildingNo ?? NoOnly.pure(),
//         schoolStreetName = schoolStreetName ?? NameOnly.pure(),
//         schoolAreaName = schoolAreaName ?? NameOnly.pure(),
//         schoolStateName = schoolStateName ?? NameOnly.pure(),
//         pinCodeNo = pinCodeNo ?? NoOnly.pure(),
//         contactNo = contactNo ?? NoOnly.pure(),
//         latLngSchool = latLngSchool ?? LatLngOnly.pure(),
//         boardName = boardName ?? NameOnly.pure();

//   final NameOnly schoolName;
//   final NoOnly affiliationNo;
//   final NoOnly schoolBuildingNo;
//   final NameOnly boardName;
//   final NameOnly schoolStreetName;
//   final NameOnly schoolAreaName;
//   final NameOnly schoolStateName;
//   final NoOnly pinCodeNo;
//   final NoOnly contactNo;
//   final LatLngOnly latLngSchool;
//   final FormzSubmissionStatus status;

//   SchoolState copyWith({
//     FormzSubmissionStatus? status,
//     NameOnly? schoolName,
//     NoOnly? affiliationNo,
//     NoOnly? schoolBuildingNo,
//     NameOnly? boardName,
//     NameOnly? schoolStreetName,
//     NameOnly? schoolAreaName,
//     NameOnly? schoolStateName,
//     NoOnly? pinCodeNo,
//     NoOnly? contactNo,
//     LatLngOnly? latLngSchool,
//   }) {
//     return SchoolState(
//       status: status ?? this.status,
//       schoolName: schoolName ?? this.schoolName,
//       affiliationNo: affiliationNo ?? this.affiliationNo,
//       schoolBuildingNo: schoolBuildingNo ?? this.schoolBuildingNo,
//       boardName: boardName ?? this.boardName,
//       schoolStreetName: schoolStreetName ?? this.schoolStreetName,
//       schoolAreaName: schoolAreaName ?? this.schoolAreaName,
//       schoolStateName: schoolStateName ?? this.schoolStateName,
//       pinCodeNo: pinCodeNo ?? this.pinCodeNo,
//       contactNo: contactNo ?? this.contactNo,
//       latLngSchool: latLngSchool ?? this.latLngSchool,
//     );
//   }

//   @override
//   List<FormzInput<dynamic, dynamic>> get inputs => [
//         schoolName,
//         affiliationNo,
//         schoolBuildingNo,
//         schoolStreetName,
//         schoolAreaName,
//         schoolStateName,
//         pinCodeNo,
//         contactNo,
//         latLngSchool,
//         boardName,
//       ];
// }

class SchoolState {
  const SchoolState();
}

class CheckValidation extends SchoolState {}

class CheckValidationSuccess extends SchoolState {}

class CompanySuccess extends SchoolState {
  //CompanySuccess(this.data);

//  final ReadCompany data;
}

class CompanyAddressSuccess extends SchoolState {
  CompanyAddressSuccess(this.data);

  final CompanyAddress data;
}

class CompanyFolderSuccess extends SchoolState {}

class CompanyLoading extends SchoolState {}

class CompanyFailure extends SchoolState {}

class FileUpLoading extends SchoolState {}

class FileUpSuccess extends SchoolState {}

class FileUpFailure extends SchoolState {}

class CompanyViewLoading extends SchoolState {}

class CompanyLoaded extends SchoolState {
  CompanyLoaded(this.company);
  final Company? company;
}

class CompanyAddressLoaded extends SchoolState {
  CompanyAddressLoaded(this.companyAddress);
  final List<CompanyAddress>? companyAddress;
}

class CompanyAddressFailure extends SchoolState {}

class CompanyAddressLoading extends SchoolState {}

class CompanySubmitLoading extends SchoolState {}

class CompanySubmitLoaded extends SchoolState {}

class CompanySubmitFailure extends SchoolState {}

class SchoolAcadamicYearLoading extends SchoolState {}

class SchoolAcadamicYearFailure extends SchoolState {}

class SchoolAcadamicYearSuccess extends SchoolState {
  SchoolAcadamicYearSuccess(this.acadamicYears);
  final List<AcadamicYear>? acadamicYears;
}

class SchoolAcadamicyearSubmitLoading extends SchoolState {}

class SchoolAcadamicyearSubmitSuccess extends SchoolState {}

class SchoolAcadamicyearSubmitFailure extends SchoolState {}

class SchoolAcadamicyearDeleteLoading extends SchoolState {}

class SchoolAcadamicyearDeleteSuccess extends SchoolState {}

class SchoolAcadamicyearDeleteFailure extends SchoolState {}

class BoardCubitDartInitial extends SchoolState {}

class BoardCubitDartLoading extends SchoolState {}

class BoardsSuccess extends SchoolState {
  const BoardsSuccess(this.companyboardlist);
  final List<Board>? companyboardlist;
}

class BoardsFailure extends SchoolState {}

class BoardsLoading extends SchoolState {}

class BoardCreateListLoaded extends SchoolState {
  const BoardCreateListLoaded(this.companyboardlist);
  final List<Board>? companyboardlist;
}

class BoardCreateListFailure extends SchoolState {}

class SearchStudentLoading extends SchoolState {}

class SearchStudentSuccess extends SchoolState {
  SearchStudentSuccess(this.studentsList);
  final List<Students>? studentsList;
}

class SearchStudentFailure extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolSuccess extends SchoolState {
  final List<SchoolsRead>? schoolList;
  SchoolSuccess(this.schoolList);
}

class SchoolFailure extends SchoolState {}

class SchoolMoreLoading extends SchoolState {}

class SchoolMoreSuccess extends SchoolState {
  final List<SchoolsRead>? schoolList;
  SchoolMoreSuccess(this.schoolList);
}

class SchoolMoreFailure extends SchoolState {}

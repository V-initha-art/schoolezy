import 'dart:typed_data';

import 'package:admin/adminrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/userrepo.dart';

part 'school_state.dart';

class SchoolCubit extends Cubit<SchoolState> {
  SchoolCubit(this.adminRepository, this.userRepository) : super(const SchoolState());

  final AdminRepository adminRepository;
  final UserRepository userRepository;
  void checkValidationFinal() {
    emit(CheckValidation());
  }

  Future<void> postCompany(
    Map<String?, Uint8List?>? images, {
    required Company company,
    required CompanyAddress companyAddress,
  }) async {
    emit(CompanyLoading());
    try {
      await adminRepository.postRestApiCompany(
        images,
        company: company,
        companyAddress: companyAddress,
      );
      emit(CompanySuccess());
    } catch (e) {
      emit(CompanyFailure());
    }
  }

  Future<void> getCompany() async {
    emit(CompanyViewLoading());
    try {
      final companyView = await adminRepository.getCompanyviewRestApi();
      //   print('11....eeeee....${companyView}');
      emit(CompanyLoaded(companyView));
    } catch (e) {
      emit(CompanyFailure());
    }
  }

  Future<void> getCompanyAddress() async {
    emit(CompanyAddressLoading());
    try {
      final companyaddressview = await adminRepository.getCompanyaddressRestApi();
      emit(CompanyAddressLoaded(companyaddressview));
    } catch (e) {
      emit(CompanyAddressFailure());
    }
  }

  Future<void> putCompanySubmit(
    Map<String?, Uint8List?>? images, {
    required Company company,
    required CompanyAddress companyAddress,
  }) async {
    emit(CompanySubmitLoading());
    try {
      await adminRepository.putCompanysubmitRestApi(
        images,
        company: company,
        companyAddress: companyAddress,
      );
      emit(CompanySubmitLoaded());
    } catch (e) {
      emit(CompanySubmitFailure());
    }
  }

  Future<void> getAcadamicSchoolYear() async {
    emit(SchoolAcadamicYearLoading());
    try {
      final acadamicYears = await adminRepository.getRestApiAcademicYears();
      emit(SchoolAcadamicYearSuccess(acadamicYears));
    } catch (e) {
      emit(SchoolAcadamicYearFailure());
    }
  }

  // Future<void> getAcadamicTerm() async {
  //   emit(SchoolAcadamicTermLoading());
  //   try {
  //     final acadamicTerm = await adminRepository.getRestApiAcademicTerms();
  //     emit(SchoolAcadamicTermSuccess(acadamicTerm));
  //   } catch (e) {
  //     emit(SchoolAcadamicTermFailure());
  //   }
  // }

  Future<void> postAcadamicSchoolYear(
    String year,
    String startDate,
    String endDate,
  ) async {
    emit(SchoolAcadamicyearSubmitLoading());
    try {
      await adminRepository.postRestApiAcademicYears(year, startDate, endDate);
      emit(SchoolAcadamicyearSubmitSuccess());
      await getAcadamicSchoolYear();
    } catch (e) {
      emit(SchoolAcadamicyearSubmitFailure());
    }
  }

  Future<void> deleteAcadamicSchoolYear(
    String year,
    // String startDate,
    // String endDate,
  ) async {
    emit(SchoolAcadamicyearDeleteLoading());
    try {
      await adminRepository.deleteRestApiAcademicYears(year);
      emit(SchoolAcadamicyearDeleteSuccess());
      await getAcadamicSchoolYear();
    } catch (e) {
      emit(SchoolAcadamicyearDeleteFailure());
    }
  }

  Future<void> getboardname() async {
    emit(BoardsLoading());
    try {
      final companyboardlist = await adminRepository.getcompanyboardname();

      emit(BoardsSuccess(companyboardlist));
    } catch (e) {
      emit(BoardsFailure());
    }
  }

  Future<void> searchStudent() async {
    emit(SearchStudentLoading());
    try {
      final studentsList = await userRepository.searchStudent();
      emit(SearchStudentSuccess(studentsList));
    } catch (e) {
      emit(SearchStudentFailure());
    }
  }

  Future<void> postboardcreatename(
    Board createlist,
  ) async {
    emit(BoardsLoading());
    try {
      final boardcreatelist = await adminRepository.postboardcreatelist(
        createlist,
      );

      emit(BoardCreateListLoaded(boardcreatelist));
    } catch (e) {
      print('$e.....');
      emit(BoardCreateListFailure());
    }
  }

  Future<void> getSchool() async {
    emit(SchoolLoading());
    try {
      final schoolList = await userRepository.getSchoolList();
      // print(schoolList);
      emit(SchoolSuccess(schoolList));
    } catch (e) {
      emit(SchoolFailure());
    }
  }

  Future<void> getMoreSchool(String query) async {
    emit(SchoolMoreLoading());
    try {
      final schoolList = await userRepository.getMoreSchoolList(query);
      emit(SchoolMoreSuccess(schoolList));
    } catch (e) {
      emit(SchoolMoreFailure());
    }
  }
// Future<void>getboardname()async{
//     emit(BoardCubitDartLoading());
//   try{
//    final companyboardlist=  await adminRepository.getcompanyboardname();
//      emit(BoardCubitDartLoaded(companyboardlist));
// }catch(e){
//     emit(BoardCubitDartFailure());

// }

// }

  // Future<void> uploadFiletoFolder(
  //   Uint8List logoFile,
  //   String fileName,
  // ) async {
  //   emit(FileUpLoading());
  //   try {
  //     await adminRepository.fileUploadRestApi(
  //       logoFile,
  //       fileName,
  //     );
  //     emit(FileUpSuccess());
  //   } catch (e) {
  //     emit(FileUpFailure());
  //   }
  // }

  // Future<void> postCompanyAddress(CompanyAddress companyAddress) async {
  //   emit(CompanyLoading());
  //   try {
  //     final postedCompanyAddress = await adminRepository.postRestApiCompanyAddress(companyAddress);
  //     emit(CompanyAddressSuccess(postedCompanyAddress));
  //     await postCompanyFolder(postedCompanyAddress.address_title!);
  //   } catch (e) {
  //     emit(CompanyFailure());
  //   }
  // }

  // Future<void> postCompanyFolder(String companyName) async {
  //   emit(CompanyLoading());
  //   try {
  //     await adminRepository.postRestApiCompanyFolder(companyName);
  //     emit(CompanyFolderSuccess());
  //   } catch (e) {
  //     emit(CompanyFailure());
  //   }
  // }
}

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:user/userrepo.dart';

part 'version_state.dart';

class VersionCubit extends Cubit<VersionState> {
  VersionCubit(this._userRepository) : super(VersionInitial());
  final UserRepository _userRepository;

  Future<void> fetchVersion() async {
    emit(VersionLoading());
    try {
      final version = await _userRepository.getPackageVersion();
      emit(VersionSuccess(version!));
    } catch (e) {
      emit(VersionFailed());
    }
    // }

    // Future<void> fcmInitialize(BuildContext context, Child child) async {
    //   emit(FcmLoading());
    //   try {
    //     await _userRepository.initializeFcm(context, child);
    //     emit(FcmSuccess());
    //   } catch (e) {
    //     emit(FcmFailed());
    //   }
    // }
  }
}

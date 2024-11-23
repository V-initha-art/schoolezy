import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user/userrepo.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required this.userRepository}) : super(AppInitial());
  final UserRepository userRepository;

  Future<void> initLocalDatabase() async {
    final path = await getApplicationPath();
    print(path + ' printing the flutter #################path');
    await userRepository.startDataBaseFromUserRepo(path);
  }

  Future<String> getApplicationPath() async {
    String? appPathLocalStorage;
    if (kIsWeb) {
      appPathLocalStorage = './';
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      appPathLocalStorage = appDocDir.path;
    }
    return appPathLocalStorage;
  }
}

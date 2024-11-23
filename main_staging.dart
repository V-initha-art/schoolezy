import 'package:admin/adminrepo.dart';
import 'package:authentication/authenticationrepo.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstoragerepo.dart';
import 'package:schoolezy/app/app.dart';
import 'package:support/support.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:user/userrepo.dart';

Future<void> main() async {
  setPathUrlStrategy();
  //await dotenv.load();
  final userRepository = UserRepository();

  runApp(
    App(
      authenticationRepository: AuthenticationRepository(userRepository),
      userRepository: userRepository,
      adminRepository: AdminRepository(),
      localStorageRepository: LocalStorageRepository(),
      supportRepository: SupportRepository(),
    ),
  );
}

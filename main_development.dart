import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:schoolezy/firebase_options_dev.dart';
import 'package:schoolezy/utility/app_basic.dart';
import 'package:schoolezy/utility/cook_app.dart';
import 'package:user/userrepo.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 await initializeApp();
}

initializeApp() async {
  try {
    await Firebase.initializeApp(
      options: DevFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  UserRepository userRepository = await UserRepository();
  await runBasic(userRepository);
  await cookApp(userRepository);
  FirebaseMessaging.onBackgroundMessage((message) => _firebaseMessagingBackgroundHandler(message));
}

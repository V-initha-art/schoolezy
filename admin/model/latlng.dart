import 'package:formz/formz.dart';

enum LatLngOnlyValidationError { invalid }

class LatLngOnly extends FormzInput<String, LatLngOnlyValidationError> with FormzInputErrorCacheMixin {
  LatLngOnly.pure() : super.pure('');
  LatLngOnly.dirty([super.value = '']) : super.dirty();

  static final _LatLngOnly = RegExp(
    r'^[\d*{2}. \d*{2}.]*$',
  );

  @override
  LatLngOnlyValidationError? validator(String value) {
    return _LatLngOnly.hasMatch(value) ? null : LatLngOnlyValidationError.invalid;
  }
}

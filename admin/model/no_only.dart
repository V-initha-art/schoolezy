import 'package:formz/formz.dart';

enum NoOnlyValidationError { invalid }

class NoOnly extends FormzInput<String, NoOnlyValidationError> with FormzInputErrorCacheMixin {
  NoOnly.pure() : super.pure('');
  NoOnly.dirty([super.value = '']) : super.dirty();

  static final _noOnly = RegExp(
    r'^[0-9 ]*$',
  );

  @override
  NoOnlyValidationError? validator(String value) {
    return _noOnly.hasMatch(value) ? null : NoOnlyValidationError.invalid;
  }
}

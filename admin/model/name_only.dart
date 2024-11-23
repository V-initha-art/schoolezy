import 'package:formz/formz.dart';

enum NameOnlyValidationError { invalid }

class NameOnly extends FormzInput<String, NameOnlyValidationError> with FormzInputErrorCacheMixin {
  NameOnly.pure() : super.pure('');
  NameOnly.dirty([super.value = '']) : super.dirty();

  static final _nameOnly = RegExp(
    r'^[a-z A-Z]*$',
  );

  @override
  NameOnlyValidationError? validator(String value) {
    return _nameOnly.hasMatch(value) ? null : NameOnlyValidationError.invalid;
  }
}

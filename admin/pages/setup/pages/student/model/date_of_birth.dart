import 'package:formz/formz.dart';

enum DateOfBirthValidationError { empty }

class DateOfBirth
    extends FormzInput<String, DateOfBirthValidationError> {
  const DateOfBirth.pure() : super.pure('');
  const DateOfBirth.dirty([super.value = '']) : super.dirty();

  @override
  DateOfBirthValidationError? validator(String value) {
    if (value.isEmpty) return DateOfBirthValidationError.empty;
    return null;
  }
}
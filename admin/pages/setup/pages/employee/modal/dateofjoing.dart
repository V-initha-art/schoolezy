import 'package:formz/formz.dart';

enum DateOfJoingValidationError { empty }

class DateOfJoing
    extends FormzInput<String, DateOfJoingValidationError> {
  const DateOfJoing.pure() : super.pure('');
  const DateOfJoing.dirty([super.value = '']) : super.dirty();

  @override
  DateOfJoingValidationError? validator(String value) {
    if (value.isEmpty) return DateOfJoingValidationError.empty;
    return null;
  }
}
import 'package:formz/formz.dart';

enum SelectedSelectedStudentNameValidationError { empty }

class SelectedStudentName
    extends FormzInput<String, SelectedSelectedStudentNameValidationError> {
  const SelectedStudentName.pure() : super.pure('');
  const SelectedStudentName.dirty([super.value = '']) : super.dirty();

  @override
  SelectedSelectedStudentNameValidationError? validator(String value) {
    if (value.isEmpty) return SelectedSelectedStudentNameValidationError.empty;
    return null;
  }
}
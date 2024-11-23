import 'package:formz/formz.dart';

enum SelectedClassValidationError { empty }

class SelectedClass
    extends FormzInput<String, SelectedClassValidationError> {
  const SelectedClass.pure() : super.pure('');
  const SelectedClass.dirty([super.value = '']) : super.dirty();

  @override
  SelectedClassValidationError? validator(String value) {
    if (value.isEmpty) return SelectedClassValidationError.empty;
    return null;
  }
}
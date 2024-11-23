import 'package:formz/formz.dart';

enum SelectEmployeeValidationError { empty }

class SelectEmployee
    extends FormzInput<String, SelectEmployeeValidationError> {
  const SelectEmployee.pure() : super.pure('');
  const SelectEmployee.dirty([super.value = '']) : super.dirty();

  @override
  SelectEmployeeValidationError? validator(String value) {
    if (value.isEmpty) return SelectEmployeeValidationError.empty;
    return null;
  }
}
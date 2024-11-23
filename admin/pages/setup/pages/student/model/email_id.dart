import 'package:formz/formz.dart';

enum SelectedEmailIDValidationError { empty }

class SelectedEmailID
    extends FormzInput<String, SelectedEmailIDValidationError> {
  const SelectedEmailID.pure() : super.pure('');
  const SelectedEmailID.dirty([super.value = '']) : super.dirty();

  @override
  SelectedEmailIDValidationError? validator(String value) {
    if (value.isEmpty) return SelectedEmailIDValidationError.empty;
    return null;
  }
}
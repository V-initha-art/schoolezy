import 'package:formz/formz.dart';

enum SelectedStatusValidationError { empty }

class SelectedStatus
    extends FormzInput<String,SelectedStatusValidationError> {
  const SelectedStatus.pure() : super.pure('');
  const SelectedStatus.dirty([super.value = '']) : super.dirty();

  @override
  SelectedStatusValidationError? validator(String value) {
    if (value.isEmpty) return SelectedStatusValidationError.empty;
    return null;
  }
}




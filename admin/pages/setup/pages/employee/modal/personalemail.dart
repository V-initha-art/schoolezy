import 'package:formz/formz.dart';

enum PersonalEmailValidationError { empty }

class PersonalEmail
    extends FormzInput<String,PersonalEmailValidationError> {
  const PersonalEmail.pure() : super.pure('');
  const PersonalEmail.dirty([super.value = '']) : super.dirty();

  @override
  PersonalEmailValidationError? validator(String value) {
    if (value.isEmpty) return PersonalEmailValidationError.empty;
    return null;
  }
}
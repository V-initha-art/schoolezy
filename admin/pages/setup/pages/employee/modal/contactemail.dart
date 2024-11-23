import 'package:formz/formz.dart';

enum ContactEmailValidationError { empty }

class ContactEmail
    extends FormzInput<String, ContactEmailValidationError> {
  const ContactEmail.pure() : super.pure('');
  const ContactEmail.dirty([super.value = '']) : super.dirty();

  @override
  ContactEmailValidationError? validator(String value) {
    if (value.isEmpty) return ContactEmailValidationError.empty;
    return null;
  }
}
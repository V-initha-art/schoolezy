import 'package:formz/formz.dart';

enum MobileNumberValidationError { empty }

class MobileNumber
    extends FormzInput<String, MobileNumberValidationError> {
  const MobileNumber.pure() : super.pure('');
  const MobileNumber.dirty([super.value = '']) : super.dirty();

  @override
  MobileNumberValidationError? validator(String value) {
    if (value.isEmpty) return MobileNumberValidationError.empty;
    return null;
  }
}
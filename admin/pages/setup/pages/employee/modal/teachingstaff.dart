import 'package:formz/formz.dart';

enum TeachingStaffValidationError { empty }

class TeachingStaff
    extends FormzInput<String,TeachingStaffValidationError> {
  const TeachingStaff.pure() : super.pure('');
  const TeachingStaff.dirty([super.value = '']) : super.dirty();

  @override
  TeachingStaffValidationError? validator(String value) {
    if (value.isEmpty) return TeachingStaffValidationError.empty;
    return null;
  }
}
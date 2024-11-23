import 'package:formz/formz.dart';

enum SectionGroupValidationError { empty }

class SectionGroup
    extends FormzInput<String, SectionGroupValidationError> {
  const SectionGroup.pure() : super.pure('');
  const SectionGroup.dirty([super.value = '']) : super.dirty();

  @override
  SectionGroupValidationError? validator(String value) {
    if (value.isEmpty) return SectionGroupValidationError.empty;
    return null;
  }
}
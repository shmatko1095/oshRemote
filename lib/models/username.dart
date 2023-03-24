import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

enum UsernameValidationError { invalid }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (EmailValidator.validate(value)) return UsernameValidationError.invalid;
    return null;
  }

}
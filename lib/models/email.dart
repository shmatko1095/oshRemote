import 'package:email_validator/email_validator.dart';

class Email {
  final String value;

  const Email({required this.value});
  const Email.pure(): value = '';

  bool isValid() => EmailValidator.validate(value);
}
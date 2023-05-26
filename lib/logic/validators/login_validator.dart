abstract class LoginValidator {
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Preencha o email';
    }
    final emailIsValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
    if (!emailIsValid) {
      return 'Formato de email inválido';
    }
    return null;
  }
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Preencha a senha';
    }
  }
}

abstract class CreateClassValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o nome da turma';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha uma descrição para a turma';
    }
    return null;
  }
}

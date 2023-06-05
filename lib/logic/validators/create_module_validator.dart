abstract class CreateModuleValidator {
   static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o nome do módulo';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha uma descrição para o módulo';
    }
    return null;
  }

  static String? validateIndex(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha a ordem do módulo';
    }
    if (int.tryParse(value) == null) {
      return 'A ordem do módulo deve ser um número inteiro';
    }
    return null;
  }
}
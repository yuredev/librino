abstract class SearchClassValidator {
  static String? searchBarValidator(String? text) {
    if (text == null || text.isEmpty) {
      return 'Preencha o código da turma';
    }
    return null;
  }
}
import 'package:image_picker/image_picker.dart';

abstract class CreateLIBRASToPhraseValidator {
  static String? validateAnswer(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Preencha a resposta do exercício';
    }
    if (value!.trim().split(' ').length < 2) {
      return 'A resposta do exercício deve ser uma frase com no mínimo 2 palavras';
    }
    return null;
  }

  static String? validateStatement(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Preencha o enunciado da questão';
    }
    if (value!.trim().length < 10) {
      return 'O enunciado da questão deve possuir no mínimo 10 caracteres';
    }
    return null;
  }

  static String? validateWords(List<String> words) {
    if (words.length < 5) {
      return 'Adicione no mínimo 5 palavras';
    }
    return null;
  }

  static String? validateVideo(XFile? video) {
    if (video == null) {
      return 'Anexe o vídeo';
    }
    return null;
  }
}

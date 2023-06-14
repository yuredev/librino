import 'package:image_picker/image_picker.dart';

abstract class CreateLIBRASToWordValidator {
  static String? validateRightChoice(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Informe a alternativa correta';
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

  static String? validateChoices(List<String> words) {
    if (words.length < 5) {
      return 'Adicione 5 alternativas de palavras';
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

import 'package:image_picker/image_picker.dart';

abstract class CreateWordToLIBRASValidator {
  static String? validateStatement(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Preencha o enunciado da questão';
    }
    if (value!.trim().length < 10) {
      return 'O enunciado da questão deve possuir no mínimo 10 caracteres';
    }
    return null;
  }

  static String? validateRightChoice(XFile? file) {
    if (file == null) {
      return 'Adicione um vídeo de sinal em LIBRAS';
    }
    return null;
  }

  static String? validateChoices(List<XFile>? list) {
    if (list == null || list.isEmpty) {
      return 'Adicione vídeos de sinais em LIBRAS';
    }
    if (list.length < 2) {
      return 'Adicione no mínimo 2 vídeos de sinais de palavras em LIBRAS';
    }
    if (list.length > 6) {
      return 'Adicione no máximo 6 vídeos de sinais de palavras em LIBRAS';
    }
    return null;
  }
}

import 'package:image_picker/image_picker.dart';

abstract class CreatePhraseToLIBRASValidator {
  static String? validateAnswerFiles(List<XFile>? list) {
    if (list == null || list.isEmpty) {
      return 'Adicione vídeos de palavras em LIBRAS';
    }    
    if (list.length < 2) {
      return 'Adicione no mínimo 2 vídeos de palavras em LIBRAS';
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
}

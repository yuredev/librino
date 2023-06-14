import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/question/libras_to_phrase/libras_to_phrase_question.dart';
import 'package:librino/data/models/question/libras_to_word/libras_to_word_question.dart';
import 'package:librino/data/models/question/phrase_to_libras/phrase_to_libras_question.dart';
import 'package:librino/data/models/question/word_to_libras/word_to_libras_question.dart';
import 'package:librino/data/repositories/question_repository.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/question/actions/question_actions_state.dart';

class QuestionActionsCubit extends Cubit<QuestionActionsState> {
  final GlobalAlertCubit _alertCubit = Bindings.get();
  final QuestionRepository _questionRepository = Bindings.get();
  final AuthCubit _authCubit = Bindings.get();

  QuestionActionsCubit() : super(InitialQuestionActionsState());

  Future<void> createPhraseToLIBRAS(
    LibrasToPhraseQuestion question,
    XFile phraseVideo,
  ) async {
    try {
      emit(CreatingQuestionState());
      final created = await _questionRepository.createLIBRASToPhrase(
        question.copyWith(creatorId: _authCubit.signedUser!.id),
        phraseVideo,
      );
      _alertCubit.fire('Questão criada com sucesso!');
      emit(QuestionCreatedState(created));
    } catch (e) {
      print(e);
      _alertCubit.fire('Erro ao criar nova questão', isErrorMessage: true);
      emit(CreateQuestionErrorState('Erro ao criar nova questão'));
    }
  }

  Future<void> createLIBRASToPhrase(
    PhraseToLibrasQuestion question,
    List<XFile> answerFiles,
  ) async {
    try {
      emit(CreatingQuestionState());
      final created = await _questionRepository.createPhraseToLIBRAS(
        question.copyWith(creatorId: _authCubit.signedUser!.id),
        answerFiles,
      );
      _alertCubit.fire('Questão criada com sucesso!');
      emit(QuestionCreatedState(created));
    } catch (e) {
      print(e);
      _alertCubit.fire('Erro ao criar nova questão', isErrorMessage: true);
      emit(CreateQuestionErrorState('Erro ao criar nova questão'));
    }
  }

  Future<void> createLIBRASToWord(
    LibrasToWordQuestion question,
    XFile video,
  ) async {
    try {
      emit(CreatingQuestionState());
      final created = await _questionRepository.createLIBRASToWord(
        question.copyWith(creatorId: _authCubit.signedUser!.id),
        video,
      );
      _alertCubit.fire('Questão criada com sucesso!');
      emit(QuestionCreatedState(created));
    } catch (e) {
      print(e);
      _alertCubit.fire('Erro ao criar nova questão', isErrorMessage: true);
      emit(CreateQuestionErrorState('Erro ao criar nova questão'));
    }
  }

  Future<void> createWordToLIBRAS({
    required WordToLibrasQuestion question,
    required List<XFile> wrongChoices,
    required XFile rightChoice,
  }) async {
    try {
      emit(CreatingQuestionState());
      final created = await _questionRepository.createWordToLIBRAS(
        question: question.copyWith(creatorId: _authCubit.signedUser!.id),
        rightChoice: rightChoice,
        wrongChoices: wrongChoices,
      );
      _alertCubit.fire('Questão criada com sucesso!');
      emit(QuestionCreatedState(created));
    } catch (e) {
      print(e);
      _alertCubit.fire('Erro ao criar nova questão', isErrorMessage: true);
      emit(CreateQuestionErrorState('Erro ao criar nova questão'));
    }
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/models/question/libras_to_phrase/libras_to_phrase_question.dart';
import 'package:librino/data/models/question/libras_to_word/libras_to_word_question.dart';
import 'package:librino/data/models/question/phrase_to_libras/phrase_to_libras_question.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/data/models/question/word_to_libras/word_to_libras_question.dart';
import 'package:librino/data/models/question_filter.dart';

const paginationSize = 20;

class QuestionRepository {
  final _collection = Bindings.get<FirebaseFirestore>().collection('questions');
  final Reference _storageRef = Bindings.get();

  Future<List<Question>> getAllPublic(QuestionFilter filter) async {
    var query = _collection.where('isPublic', isEqualTo: true);
    final snapshot = await query.get();
    final data = snapshot.docs.map((e) => Question.fromJson(e.data())).toList();
    return data;
  }

  Future<LibrasToPhraseQuestion> createLIBRASToPhrase(
    LibrasToPhraseQuestion question,
    XFile video,
  ) async {
    final docRef = await _collection.add(question.toJson());
    final snapshot = await docRef.get();
    final data = snapshot.data()!;
    data.update('id', (_) => docRef.id);
    final videoRef = _storageRef
        .child('questions')
        .child('user_${question.creatorId!}')
        .child('type_${data['type']}')
        // TODO: considerar a extensão do arquivo (não é sempre mp4) [Melhor obrigar a anexar MP4 não?]
        .child('question_${data['id']}.mp4');
    final snap = await videoRef.putFile(File(video.path));
    final url = await snap.ref.getDownloadURL();
    data.update('assetUrl', (_) => url);
    await docRef.update(data);
    return LibrasToPhraseQuestion.fromJson(data);
  }

  Future<PhraseToLibrasQuestion> createPhraseToLIBRAS(
    PhraseToLibrasQuestion question,
    List<XFile> answerFiles,
  ) async {
    final docRef = await _collection.add(question.toJson());
    final snapshot = await docRef.get();
    final data = snapshot.data()!;
    data.update('id', (_) => docRef.id);
    final urls = <String>[];
    for (var i = 0; i < answerFiles.length; i++) {
      final videoRef = _storageRef
          .child('questions')
          .child('user_${question.creatorId!}')
          .child('type_${data['type']}')
          .child('question_${data['id']}')
          .child('$i.gif');
      final snap = await videoRef.putFile(File(answerFiles[i].path));
      final url = await snap.ref.getDownloadURL();
      urls.add(url);
    }
    data.update('answerUrls', (_) => urls);
    await docRef.update(data);
    return PhraseToLibrasQuestion.fromJson(data);
  }

  Future<LibrasToWordQuestion> createLIBRASToWord(
    LibrasToWordQuestion question,
    XFile video,
  ) async {
    final docRef = await _collection.add(question.toJson());
    final snapshot = await docRef.get();
    final data = snapshot.data()!;
    data.update('id', (_) => docRef.id);
    final videoRef = _storageRef
        .child('questions')
        .child('user_${question.creatorId!}')
        .child('type_${data['type']}')
        // TODO: considerar a extensão do arquivo (não é sempre mp4) [Melhor obrigar a anexar MP4 não?]
        .child('question_${data['id']}.mp4');
    final snap = await videoRef.putFile(File(video.path));
    final url = await snap.ref.getDownloadURL();
    data.update('assetUrl', (_) => url);
    await docRef.update(data);
    return LibrasToWordQuestion.fromJson(data);
  }

  Future<WordToLibrasQuestion> createWordToLIBRAS({
    required WordToLibrasQuestion question,
    required XFile rightChoice,
    required List<XFile> wrongChoices,
  }) async {
    final docRef = await _collection.add(question.toJson());
    final snapshot = await docRef.get();
    final data = snapshot.data()!;
    data.update('id', (_) => docRef.id);
    final ref = _storageRef
        .child('questions')
        .child('user_${question.creatorId!}')
        .child('type_${data['type']}');
    final wrongChoicesUrls = <String>[];
    final rightChoiceRef = ref.child('question_${data['id']}.gif');
    final snap = await rightChoiceRef.putFile(File(rightChoice.path));
    final rightChoiceURL = await snap.ref.getDownloadURL();
    for (var i = 0; i < wrongChoices.length; i++) {
      final wrongChoiceRef =
          ref.child('question_${data['id']}').child('$i.gif');
      final snap = await wrongChoiceRef.putFile(File(wrongChoices[i].path));
      final url = await snap.ref.getDownloadURL();
      wrongChoicesUrls.add(url);
    }
    data.update('rightChoiceUrl', (_) => rightChoiceURL);

    data.update('choicesUrls', (_) => [...wrongChoicesUrls, rightChoiceURL]);
    await docRef.update(data);
    return WordToLibrasQuestion.fromJson(data);
  }

  Future<List<Question>> loadFromLesson(Lesson lesson) async {
    final questions = <Question>[];
    for (final id in lesson.questionIds) {
      var snap = await _collection.doc(id).get();
      questions.add(Question.fromJson(snap.data()!));
    }
    return questions;
  }

  Future<void> deletePrivatesFromUser(String id) async {
    final snap = await _collection
        .where('ownerId', isEqualTo: id)
        .where('isPublic', isEqualTo: false)
        .get();
    for (final doc in snap.docs) {
      await _collection.doc(doc.id).delete();
    }
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/question/libras_to_phrase/libras_to_phrase_question.dart';
import 'package:librino/data/models/question/phrase_to_libras/phrase_to_libras_question.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/data/models/question_filter.dart';

const paginationSize = 20;

class QuestionRepository {
  final _collection = Bindings.get<FirebaseFirestore>().collection('questions');
  final Reference _storageRef = Bindings.get();

  Future<List<Question>> getAll(QuestionFilter filter, Question? last) async {
    //TODO: como pega a página?
    final query =
        last == null ? _collection : _collection.startAt([last.toJson()]);
    final snapshot = await query.limit(paginationSize).get();
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
}
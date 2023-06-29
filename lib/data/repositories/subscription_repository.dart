import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/errors/firebase_custom_error.dart';
import 'package:librino/data/models/subscription/subscription.dart';

class SubscriptionRepository {
  final _collection =
      Bindings.get<FirebaseFirestore>().collection('subscriptions');

  Future<List<Subscription>> getBySubscriberId(String subscriberId) async {
    final query = _collection.where('subscriberId', isEqualTo: subscriberId);
    final querySnap = await query.get();
    final subs =
        querySnap.docs.map((e) => Subscription.fromJson(e.data())).toList();
    return subs;
  }

  Future<Subscription?> getBySubscriberAndClass(
    String subscriberId,
    String classId,
  ) async {
    try {
      final query = _collection
          .where('subscriberId', isEqualTo: subscriberId)
          .where('classId', isEqualTo: classId)
          .limit(1);
      final querySnap = await query.get();
      final subs = Subscription.fromJson(querySnap.docs.first.data());
      return subs;
    } catch (e) {
      if (e is StateError && e.message == 'No element') {
        return null;
      } else {
        print(e);
        rethrow;
      }
    }
  }

  Future<List<Subscription>> getByResponsibleId(String responsibleId) async {
    final query = _collection.where('responsibleId', isEqualTo: responsibleId);
    final querySnap = await query.get();
    final subs =
        querySnap.docs.map((e) => Subscription.fromJson(e.data())).toList();
    return subs;
  }

  Future<Subscription> create(Subscription subscription) async {
    if (await didAlreadyExists(
        subscription.subscriberId, subscription.classId)) {
      throw FirebaseCustomError(
        'Já existe uma solicitação de matrícula nesta turma',
      );
    }
    final docRef = await _collection.add(subscription.toJson());
    final snapshot = await docRef.get();
    final data = snapshot.data()!;
    data.update('id', (_) => docRef.id);
    await docRef.update(data);
    return Subscription.fromJson(data);
  }

  Future<bool> didAlreadyExists(String subscriberId, String classId) async {
    final query = _collection
        .where('subscriberId', isEqualTo: subscriberId)
        .where('classId', isEqualTo: classId);
    final querySnap = await query.get();
    return querySnap.docs.isNotEmpty;
  }

  Future<List<Subscription>> getFromClass(String? classId) async {
    final query = _collection.where('classId', isEqualTo: classId);
    final querySnap = await query.get();
    final subs =
        querySnap.docs.map((e) => Subscription.fromJson(e.data())).toList();
    return subs;
  }

  Future<List<Subscription>> getActivesFromClass(String? classId) async {
    final query = _collection
        .where('classId', isEqualTo: classId)
        .where('subscriptionStage', isEqualTo: 'approved');
    final querySnap = await query.get();
    final subs =
        querySnap.docs.map((e) => Subscription.fromJson(e.data())).toList();
    return subs;
  }

  Future<Subscription?> getById(String id) async {
    final subs = _collection.where('id', isEqualTo: id);
    try {
      final querySnap = await subs.get();
      final all =
          querySnap.docs.map((e) => Subscription.fromJson(e.data())).toList();
      return all.first;
    } catch (e) {
      if (e is StateError && e.message == 'No element') {
        return null;
      } else {
        print(e);
        rethrow;
      }
    }
  }

  Future<void> approve(String subscriptionId) async {
    final docRef = _collection.doc(subscriptionId);
    final snap = await docRef.get();
    final data = snap.data()!;
    data.update(
      'subscriptionStage',
      (value) => Subscription.stageToString(SubscriptionStage.approved),
    );
    await docRef.update(data);
  }

  Future<void> repprove(String subscriptionId) async {
    final docRef = _collection.doc(subscriptionId);
    final snap = await docRef.get();
    final data = snap.data()!;
    data.update(
      'subscriptionStage',
      (value) => Subscription.stageToString(SubscriptionStage.repproved),
    );
    await docRef.update(data);
  }

  Future<void> delete(String? id) async {
    await _collection.doc(id).delete();
  }

  Future<int> getParticipantsCount(String? id) async {
    final query = _collection.where('classId', isEqualTo: id).count();
    final snap = await query.get();
    return snap.count;
  }
}

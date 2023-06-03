// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:librino/core/enums/enums.dart';

part 'subscription.g.dart';

@JsonSerializable()
class Subscription extends Equatable {
  final String? id;
  final String classId;
  @JsonKey(includeToJson: false)
  final String? className;
  final String subscriberId;
  @JsonKey(includeToJson: false)
  final String? subscriberName;
  @JsonKey(includeToJson: false)
  final String? responsibleName;

  final SubscriptionStage subscriptionStage;
  final DateTime requestDate;
  final DateTime? responseDate;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  const Subscription({
    this.id,
    required this.classId,
    this.responsibleName,
    this.className,
    required this.subscriberId,
    this.subscriberName,
    required this.subscriptionStage,
    this.responseDate,
    required this.requestDate,
  });

  static String stageToString(SubscriptionStage stage) {
    return _$SubscriptionStageEnumMap[stage]!;
  }

  @override
  List<Object?> get props => [
        classId,
        className,
        subscriberId,
        subscriberName,
        subscriptionStage,
        requestDate,
        responseDate,
        responsibleName,
        id,
      ];

  Subscription copyWith({
    String? id,
    String? classId,
    String? className,
    String? subscriberId,
    String? responsibleId,
    String? subscriberName,
    SubscriptionStage? subscriptionStage,
    DateTime? requestDate,
    DateTime? responseDate,
    String? responsibleName,
  }) {
    return Subscription(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      subscriberId: subscriberId ?? this.subscriberId,
      subscriberName: subscriberName ?? this.subscriberName,
      subscriptionStage: subscriptionStage ?? this.subscriptionStage,
      requestDate: requestDate ?? this.requestDate,
      responseDate: responseDate ?? this.responseDate,
      responsibleName: responsibleName ?? this.responsibleName,
    );
  }
}

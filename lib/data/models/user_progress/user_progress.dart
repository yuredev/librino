import 'package:equatable/equatable.dart';

import 'package:librino/data/models/module/module.dart';

class UserProgress extends Equatable {
  final Module module;
  final int lessonsCompletedCount;

  const UserProgress(this.module, this.lessonsCompletedCount);

  @override
  List<Object?> get props => [module, lessonsCompletedCount];

  UserProgress copyWith({
    Module? module,
    int? lessonsCompletedCount,
  }) {
    return UserProgress(
      module ?? this.module,
      lessonsCompletedCount ?? this.lessonsCompletedCount,
    );
  }
}

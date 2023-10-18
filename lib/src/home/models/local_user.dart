import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.id,
    required this.isStaff,
    this.motivationLevelToday,
  });

  final String id;
  final bool isStaff;
  final int? motivationLevelToday;

  @override
  List<Object?> get props => [id, isStaff, motivationLevelToday];

  LocalUser copyWith({
    String? id,
    bool? isStaff,
    int? motivationLevelToday,
  }) {
    return LocalUser(
      id: id ?? this.id,
      isStaff: isStaff ?? this.isStaff,
      motivationLevelToday: motivationLevelToday ?? this.motivationLevelToday,
    );
  }
}

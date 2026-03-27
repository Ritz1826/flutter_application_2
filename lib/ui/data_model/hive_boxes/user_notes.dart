import 'package:hive_flutter/hive_flutter.dart';

part 'user_notes.g.dart';

@HiveType(typeId: 1)
class UserNotes extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime timeStamp;

  UserNotes({
    required this.title,
    required this.description,
    required this.timeStamp,
  });
}

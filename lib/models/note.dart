import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  Note(this.name, this.description);
}

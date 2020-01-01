import 'package:hive/hive.dart';

part 'instary.g.dart';

// create hive adapter
// flutter packages pub run build_runner build
@HiveType()
class Instary {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  Instary(this.title, this.content);
}
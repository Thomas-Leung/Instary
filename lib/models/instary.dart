import 'package:hive/hive.dart';

part 'instary.g.dart';

// create hive adapter
// flutter packages pub run build_runner build
@HiveType()
class Instary {
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime dateTime;
  @HiveField(2)
  String title;
  @HiveField(3)
  String content;
  @HiveField(4)
  double happinessLv;
  @HiveField(5)
  double tirednessLv;
  @HiveField(6)
  double stressfulnessLv;
  @HiveField(7)
  List<String> imagePaths;

  Instary(this.id, this.dateTime, this.title, this.content, this.happinessLv,
      this.tirednessLv, this.stressfulnessLv, this.imagePaths);
}

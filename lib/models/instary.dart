import 'package:hive/hive.dart';

part 'instary.g.dart';

// create hive adapter
// flutter packages pub run build_runner build
@HiveType()
class Instary {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  double happinessLv;
  @HiveField(4)
  double tirednessLv;
  @HiveField(5)
  double stressfulnessLv;

  Instary(this.dateTime, this.title, this.content, this.happinessLv,
      this.tirednessLv, this.stressfulnessLv);
}

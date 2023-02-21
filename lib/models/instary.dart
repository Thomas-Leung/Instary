import 'package:hive/hive.dart';

part 'instary.g.dart';

// create hive adapter
// flutter packages pub run build_runner build
// typeId is used to identify the class (so you can change class name)
// no need to change typeId when update schema
@HiveType(typeId: 1)
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
  List<String> mediaPaths;
  @HiveField(8)
  DateTime? bedTime;
  @HiveField(9)
  DateTime? wakeUpTime;
  @HiveField(10)
  List<String>? tags;

  Instary(
      this.id,
      this.dateTime,
      this.title,
      this.content,
      this.happinessLv,
      this.tirednessLv,
      this.stressfulnessLv,
      this.mediaPaths,
      this.bedTime,
      this.wakeUpTime,
      this.tags);

  Instary.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        dateTime = new DateTime.fromMillisecondsSinceEpoch(json["dateTime"]),
        title = json["title"],
        content = json["content"],
        happinessLv = json["happinessLv"],
        tirednessLv = json["tirednessLv"],
        stressfulnessLv = json["stressfulnessLv"],
        mediaPaths = json["mediaPaths"]
            .cast<String>(), // cast from List<dynamic> to List<String>
        bedTime = json["bedTime"] != null
            ? new DateTime.fromMillisecondsSinceEpoch(json["bedTime"])
            : null,
        wakeUpTime = json["wakeUpTime"] != null
            ? new DateTime.fromMillisecondsSinceEpoch(json["wakeUpTime"])
            : null,
        tags = json["tags"]?.cast<String>() ??
            []; // if tags are null then assign empty list instead

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "dateTime": this.dateTime.millisecondsSinceEpoch,
      "title": this.title,
      "content": this.content,
      "happinessLv": this.happinessLv,
      "tirednessLv": this.tirednessLv,
      "stressfulnessLv": this.stressfulnessLv,
      "mediaPaths": this.mediaPaths,
      "bedTime": this.bedTime?.millisecondsSinceEpoch,
      "wakeUpTime": this.wakeUpTime?.millisecondsSinceEpoch,
      "tags": this.tags
    };
  }
}

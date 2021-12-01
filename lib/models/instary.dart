import 'package:hive/hive.dart';

part 'instary.g.dart';

// create hive adapter
// flutter packages pub run build_runner build
// typeId is used to identify the class (so you can change class name)
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
  List<String> imagePaths;
  @HiveField(8)
  List<String> videoPaths;

  Instary(this.id, this.dateTime, this.title, this.content, this.happinessLv,
      this.tirednessLv, this.stressfulnessLv, this.imagePaths, this.videoPaths);

  Instary.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        dateTime = new DateTime.fromMillisecondsSinceEpoch(json["dateTime"]),
        title = json["title"],
        content = json["content"],
        happinessLv = json["happinessLv"],
        tirednessLv = json["tirednessLv"],
        stressfulnessLv = json["stressfulnessLv"],
        imagePaths = json["imagePaths"]
            .cast<String>(), // cast from List<dynamic> to List<String>
        videoPaths = json["videoPaths"].cast<String>();

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "dateTime": this.dateTime.millisecondsSinceEpoch,
      "title": this.title,
      "content": this.content,
      "happinessLv": this.happinessLv,
      "tirednessLv": this.tirednessLv,
      "stressfulnessLv": this.stressfulnessLv,
      "imagePaths": this.imagePaths,
      "videoPaths": this.videoPaths
    };
  }
}

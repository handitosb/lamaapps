//set table name
final String tableAchievements = "achievement";

///Set the column names
///
/// Author: F.Brecher
class AchievementsFields {
  static final String columnAchievementsId = "id";
  static final String columnAchievementsName = "name";
}

///This class help to work with the data's from the achievement table
///
/// Author: F.Brecher
class Achievement {
  int id;
  String name;

  Achievement({this.name});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      AchievementsFields.columnAchievementsName: name,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  Achievement.fromMap(Map<String, dynamic> map) {
    id = map[AchievementsFields.columnAchievementsId];
    name = map[AchievementsFields.columnAchievementsName];
  }
}

class AchievementList {
  List<Achievement> achivments;
  AchievementList(this.achivments);

  AchievementList.fromJson(Map<String, dynamic> json) {
    if (json['achievementList'] != null) {
      achivments = <Achievement>[];
      json['achievementList'].forEach((v) {
        achivments.add(new Achievement.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.achivments != null) {
      data['achievementList'] = this.achivments.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

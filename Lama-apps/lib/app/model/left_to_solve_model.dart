import 'dart:convert';

//set table name
final String tableLeftToSolve = "left_to_solve";

///Set the column names
///
/// Author: F.Brecher
class LeftToSolveFields {
  static const String columnLeftToSolveID = "id";
  static const String columnTaskString = "task_string";
  static const String columnUserLTSId = "user_id";
  static const String columnLeftToSolve = "left_to_solve";
  static const String columnDoesStillExist = "does_still_exist";
}

///This class help to work with the data's from the leftToSolve table
///
/// Author: F.Brecher
class LeftToSolve {
  int id;
  String taskString;
  int userLTSId;
  int leftToSolve;
  int doesStillExist;
  LeftToSolve({
    this.id,
    this.taskString,
    this.userLTSId,
    this.leftToSolve,
    this.doesStillExist,
  });

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      LeftToSolveFields.columnTaskString: taskString,
      LeftToSolveFields.columnUserLTSId: userLTSId,
      LeftToSolveFields.columnLeftToSolve: leftToSolve,
      LeftToSolveFields.columnDoesStillExist: doesStillExist
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  LeftToSolve.fromMap(Map<String, dynamic> map) {
    id = map[LeftToSolveFields.columnLeftToSolveID];
    taskString = map[LeftToSolveFields.columnTaskString];
    userLTSId = map[LeftToSolveFields.columnUserLTSId];
    leftToSolve = map[LeftToSolveFields.columnLeftToSolve];
    doesStillExist = map[LeftToSolveFields.columnDoesStillExist];
  }
}

class LeftToSolveList {
  List<LeftToSolve> leftToSolve;
  LeftToSolveList(this.leftToSolve);

  LeftToSolveList.fromJson(Map<String, dynamic> json) {
    if (json['LeftToSolveList'] != null) {
      leftToSolve = <LeftToSolve>[];
      json['LeftToSolveList'].forEach((v) {
        leftToSolve.add(new LeftToSolve.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.leftToSolve != null) {
      data['LeftToSolveList'] = this.leftToSolve.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

//set table name
final String tableTaskUrl = "task_url";

///Set the column names
///
/// Author: F.Brecher
class TaskUrlFields {
  static final String columnId = "id";
  static final String columnTaskUrl = "url";
}

///This class help to work with the data's from the taskUrl table
///
/// Author: F.Brecher
class TaskUrl {
  int id;
  String url;

  TaskUrl({this.url});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{TaskUrlFields.columnTaskUrl: url};
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  TaskUrl.fromMap(Map<String, dynamic> map) {
    id = map[TaskUrlFields.columnId];
    url = map[TaskUrlFields.columnTaskUrl];
  }
}

class TaskUrlList {
  List<TaskUrl> taskUrlFieldslList;
  TaskUrlList(this.taskUrlFieldslList);

  TaskUrlList.fromJson(Map<String, dynamic> json) {
    if (json['taskUrlFieldslList'] != null) {
      taskUrlFieldslList = <TaskUrl>[];
      json['taskUrlFieldslList'].forEach((v) {
        taskUrlFieldslList.add(new TaskUrl.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.taskUrlFieldslList != null) {
      data['taskUrlFieldslList'] =
          this.taskUrlFieldslList.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

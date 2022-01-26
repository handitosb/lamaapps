//set table name
final String tableSubjects = "subject";

///Set the column names
///
/// Author: F.Brecher
class SubjectsFields {
  static final String columnSubjectsId = "id";
  static final String columnSubjectsName = "name";
}

///This class help to work with the data's from the subject table
///
/// Author: F.Brecher
class Subject {
  int id;
  String name;

  Subject({this.name});

  ///Map the variables
  ///
  ///{@return} Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SubjectsFields.columnSubjectsName: name,
    };
    return map;
  }

  ///get the data from the map
  ///
  ///{@param} Map<String, dynamic> map
  Subject.fromMap(Map<String, dynamic> map) {
    id = map[SubjectsFields.columnSubjectsId];
    name = map[SubjectsFields.columnSubjectsName];
  }
}

class SubjectList {
  List<Subject> subjectsList;
  SubjectList(this.subjectsList);

  SubjectList.fromJson(Map<String, dynamic> json) {
    if (json['subjects'] != null) {
      subjectsList = <Subject>[];
      json['subjects'].forEach((v) {
        subjectsList.add(new Subject.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.subjectsList != null) {
      data['subjects'] = this.subjectsList.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:http/http.dart' as http;

class TasksetEditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
  
}

Future<TasksetRepository> tasksetEdit(String taskType, int reward, String lamaText, int leftToSolve) async {
  var response = await http.post(Uri.https('github.com', 'handitosb/lamaapps/edit/main/JSON_Test/mathetest.json'),
      body: {"taskType": taskType, "reward": reward, "lamaText": lamaText, "leftToSolve": leftToSolve});
  
  var data = response.body;
  print(data);  
}

class TasksetEditScreenState extends State<TasksetEditScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
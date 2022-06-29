import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist/models/task.dart';

class TaskRepository {
  late SharedPreferences sharedPreferences;

  TaskRepository() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }

  void saveTaskList(List<Task> tasks) {
    final jsonString = json.encode(tasks);
    sharedPreferences.setString('tasks', jsonString);
  }

  Future<List<Task>> getTask() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString('tasks') ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Task.fromJson(e)).toList();
  }
}

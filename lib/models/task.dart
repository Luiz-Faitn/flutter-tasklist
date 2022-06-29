class Task{
  Task({required this.title, required this.dataTask});

  Task.fromJson(Map<String, dynamic> json)
  : title = json['title'],
  dataTask = DateTime.parse(json['dataTask']);

  String title;
  DateTime dataTask;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dataTask': dataTask.toIso8601String(),
    };
  }
}
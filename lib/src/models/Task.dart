class TasksModel {
  List<TaskModel> items = new List();

  TasksModel();

  TasksModel.fromJsonList({List<dynamic> jsonList}) {
    if (jsonList == null) return;

    for (final item in jsonList) {
      final task = TaskModel.fromJsonMap(json: item);

      items.add(task);
    }
  }
}

class TaskModel {
  int id;
  String message;
  int userId;
  int completed;
  String date;

  TaskModel({this.id, this.message, this.userId, this.completed, this.date});

  TaskModel.fromJsonMap({Map<String, dynamic> json}) {
//    print(json);
    this.id = json["id"];
    this.userId = json["user_id"];
    this.message = json["message"];
    this.completed = json["completed"];
    this.date = json["date"];
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "message": message,
        "completed": completed,
        "date": date,
      };
}

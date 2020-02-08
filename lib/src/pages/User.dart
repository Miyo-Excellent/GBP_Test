import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbp_test/src/models/Task.dart';
import 'package:gbp_test/src/models/User.dart';
import 'package:gbp_test/src/providers/Database.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  bool _init = false;

  UserModel _data;

  List<TaskModel> pendingTasks = new List();

  List<TaskModel> completedTasks = new List();

  final TextEditingController _modalTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {
      _data = ModalRoute.of(context).settings.arguments;

      if (!_init) {
        _init = true;

        _getTasks();
      }
    });

    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: _floatingActionButton(context: context),
    );
  }

  Widget _appBar() => AppBar(
        title: _appBarTitle(title: "Actividades de Usuario"),
        centerTitle: true,
      );

  Widget _body() => Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                _header(context: context),
                _pending(context: context),
                SizedBox(
                  height: 20.0,
                ),
                _completed(context: context)
              ],
            )
          ],
        ),
      );

  Widget _floatingActionButton({BuildContext context}) => FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 35.0,
        ),
        onPressed: () {
          _createNewActivity(context: context, title: "Crear actividad");
        },
      );

  Widget _appBarTitle({String title}) => Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
      );

  Widget _header({BuildContext context}) => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54.withOpacity(0.2),
              blurRadius: 10.0,
              offset: Offset(
                0.0,
                0.0,
              ),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ClipRRect(
              child: Image.network(
                _data.avatarUrl,
                width: 50.0,
                height: 50.0,
              ),
              borderRadius: BorderRadius.circular(100.0),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  _data.login,
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  _data.reposUrl,
                  style: TextStyle(
                      color: Colors.black12,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      );

  Widget _pending({BuildContext context}) => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[_pendingHeader(), _pendingList(context: context)],
      );

  Widget _pendingHeader() => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        color: Colors.orangeAccent,
        child: Text(
          "Pendientes",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      );

  Widget _pendingList({BuildContext context}) => Column(
        children: pendingTasks
            .map((TaskModel task) => _taskCard(context: context, task: task))
            .toList(),
      );

  Widget _completedHeader() => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        color: Colors.greenAccent,
        child: Text(
          "Completados",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      );

  Widget _completed({BuildContext context}) => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _completedHeader(),
          _completedList(context: context)
        ],
      );

  Widget _completedList({BuildContext context}) => Column(
        children: completedTasks
            .map((TaskModel task) => _taskCard(context: context, task: task))
            .toList(),
      );

  Widget _taskCard({BuildContext context, TaskModel task}) => Card(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                tristate: true,
                value: task.completed == 1,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (bool val) =>
                    _toggleTaskStatus(status: val, tasks: task),
                activeColor: Colors.greenAccent,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text(task.message)],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: Center(
                    child: IconButton(
                  onPressed: () => _deleteTask(task),
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                  ),
                )),
              ),
            ],
          ),
        ),
        elevation: 10.0,
      );

  void _toggleTaskStatus({bool status, TaskModel tasks}) {
    if (tasks.completed == 0) {
      final TaskModel taskUpdated = TaskModel(
          id: tasks.id,
          message: tasks.message,
          userId: tasks.userId,
          completed: 1,
          date: tasks.date);

//      pendingTasks.removeWhere(
//          (TaskModel task) => identical(task.userId, tasks.userId));

//      completedTasks.add(taskUpdated);

      _updateTask(taskUpdated);
    } else {
      final TaskModel taskUpdated = TaskModel(
          id: tasks.id,
          message: tasks.message,
          userId: tasks.userId,
          completed: 0,
          date: tasks.date);

//      completedTasks
//          .removeWhere((TaskModel task) => identical(task.userId, tasks.userId));

//      pendingTasks.add(taskUpdated);

      _updateTask(taskUpdated);
    }
  }

  void _getTasks() {
    DatabaseProvider.db.getTasks().then((TasksModel _tasks) {
      final tasks = _tasks.items;

      List<TaskModel> _pendingTasks = new List();
      List<TaskModel> _completedTasks = new List();

      tasks.forEach((TaskModel task) {
        if (task.userId == _data.id) {
          if (task.completed == 0) {
            _pendingTasks.add(task);
          } else {
            _completedTasks.add(task);
          }
        }
      });

      setState(() {
        pendingTasks = _pendingTasks;
        completedTasks = _completedTasks;
      });
    });

//        DatabaseProvider.db.deleteTasks().then((int result) {});
//    DatabaseProvider.db.dropTasks().then((Null _) {});

//    DatabaseProvider.db
//        .getCompletedTasks(_data)
//        .then((TasksModel _completedTasks) {
//      completedTasks = _completedTasks.items;
//    });

//    DatabaseProvider.db.getPendingTasks(_data).then((TasksModel _pendingTasks) {
//      pendingTasks = _pendingTasks.items;
//    });
  }

  void _updateTask(TaskModel task) {
    DatabaseProvider.db.updateTask(task).then((int result) {});

    _getTasks();
  }

  void _deleteTask(TaskModel task) {
    DatabaseProvider.db.deleteTask(task).then((int result) {});

    _getTasks();
  }

  _createNewActivity({BuildContext context, String title}) {
    _hidden() {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogsContext) => AlertDialog(
              elevation: 15.0,
              title: Column(
                children: <Widget>[
                  Text(
                    "Crear actividad",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider()
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _modalTitleController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Descripción",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54))),
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Colors.white,
                  child: Text("Cancelar",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    _hidden();
                  },
                ),
                MaterialButton(
                  color: Colors.white,
                  child: Text("Guardar",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if (_modalTitleController.value.text == "") return;

                    final TaskModel newTask = TaskModel(
                        message: _modalTitleController.value.text.trim(),
                        userId: _data.id,
                        completed: 0,
                        date: DateTime.now().toString());

                    DatabaseProvider.db
                        .createTask(newTask)
                        .then((int result) {});

                    _modalTitleController.clear();

                    _hidden();
                    _getTasks();
                  },
                )
              ],
            ));
  }
}

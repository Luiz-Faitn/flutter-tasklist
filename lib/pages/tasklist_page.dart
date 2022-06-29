import 'package:flutter/material.dart';
import 'package:tasklist/models/task.dart';
import 'package:tasklist/repositories/task_repository.dart';
import 'package:tasklist/widgets/task_list_item.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> tasks = [];

  String? erroMsg;

  final TextEditingController taskController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();

  @override
  void initState() {
    super.initState();
    taskRepository.getTask().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  void adicionar() {
    if(taskController.text.isEmpty) {
      setState(() {
        erroMsg = "Favor preencher o titulo!";
      });
      return;
    }

    String text = taskController.text;
    setState(() {
      Task task = new Task(title: text, dataTask: DateTime.now());
      tasks.add(task);
      erroMsg = null; 
    });
    taskController.clear();
    taskRepository.saveTaskList(tasks);
  }

  void onDelete(task) {
    Task taskRemovida = task;
    int taskPos = tasks.indexOf(task);

    setState(() {
      tasks.remove(task);
    });
    taskRepository.saveTaskList(tasks);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.lightBlue,
        content: Text(
          'Tarefa ${task.title}foi excluido com sucesso!',
        ),
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Colors.grey[600],
          onPressed: () {
            setState(() {
              tasks.insert(taskPos, taskRemovida);
              taskRepository.saveTaskList(tasks);
            });
          },
        ),
      ),
    );
  }

  void deleteAllTasks() {
    setState(() {
      tasks.clear();
    });
    taskRepository.saveTaskList(tasks);
  }

  void limparTudo() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Limpar tudo?'),
              content: const Text(
                  'Você tem certeza que quer apagar todas as tasks?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAllTasks();
                  },
                  child: const Text(
                    "Limpar tudo!",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: "Adicione uma Task",
                            hintText: "Ex: Tarefa - 01",
                            errorText: erroMsg,
                            labelStyle: const TextStyle(color: Colors.deepPurple),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepPurple,
                                width: 2,
                              )
                            )
                          ),
                        ),
                      ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: adicionar,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in tasks)
                        TaskListItem(
                          task: task,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Você possui ${tasks.length} tarefas pendentes",
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: limparTudo,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Text("Limpar Tudo"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

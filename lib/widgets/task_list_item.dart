import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tasklist/models/task.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    Key? key, 
    required this.task,
    required this.onDelete,
    }) : super(key: key);

  final Task task;
  final Function(Task) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(task.dataTask),
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                task.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actionPane: const SlidableDrawerActionPane(),
        actions: [
          IconSlideAction(
            color: Colors.greenAccent,
            icon: Icons.share,
            caption: "Compartilhar",
            onTap: () {
              print("Excluindo Item!");
            },
          ),
        ],
        secondaryActions: [
          IconSlideAction(
            color: Colors.redAccent,
            icon: Icons.delete,
            caption: "Deletar",
            onTap: () {
              onDelete(task);
            },
          ),
          IconSlideAction(
            color: Colors.lightBlue,
            icon: Icons.edit,
            caption: "Editar",
            onTap: () {
              print("Excluindo Item!");
            },
          ),
        ],
      ),
    );
  }
}

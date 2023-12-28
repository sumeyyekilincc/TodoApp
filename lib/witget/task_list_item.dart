import 'package:Todoapp/data/local_storage.dart';
import 'package:Todoapp/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';

class TaskItem extends StatefulWidget {
 final Task task;
  const TaskItem({required this.task, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNAmeController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
        _taskNAmeController.text = widget.task.name;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: ListTile(
          leading: GestureDetector(
            onTap: () {
              widget.task.isCompleted = !widget.task.isCompleted;
              _localStorage.updateTask(task: widget.task);
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                  color: widget.task.isCompleted ? Colors.green : Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.8),
                  shape: BoxShape.circle),
              child: const Icon(Icons.check),
            ),
          ),
          title: widget.task.isCompleted
              ? Text(
                  widget.task.name,
                  style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey),
                )
              : TextField(
                  minLines: 1,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  controller: _taskNAmeController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  onSubmitted: (yeniDeger) {
                    if (yeniDeger.length > 3) {
                      widget.task.name = yeniDeger;
                      _localStorage.updateTask(task: widget.task);
                    }
                  },
                ),
          trailing: Text(
            DateFormat("hh:mm a").format(widget.task.createdAt),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          )),
    );
  }
}

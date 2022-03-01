import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../all_provider.dart';
import '../models/task_model.dart';

// ignore: must_be_immutable
class TaskItem extends ConsumerWidget {
  Task task;
  TaskItem({Key? key, required this.task}) : super(key: key);
  final TextEditingController _taskNameController = TextEditingController();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var gorev = ref.watch(todosProvider.notifier).getTask(id: task.id);
    _taskNameController.text = gorev!.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            gorev.isCompleted = !gorev.isCompleted;
            await ref.read(todosProvider.notifier).updateTask(task: gorev);
            
          },
          child: Container(
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: gorev.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                shape: BoxShape.circle),
          ),
        ),
        title:  gorev.isCompleted
            ? Text(
                gorev.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskNameController,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (yeniDeger) async {
                  if (yeniDeger.length > 3) {
                    gorev.name = yeniDeger;
                    await ref
                        .read(todosProvider.notifier)
                        .updateTask(task: gorev);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(task.createdAt),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
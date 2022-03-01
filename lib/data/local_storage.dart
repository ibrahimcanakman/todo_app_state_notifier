import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Task? getTask({required String id});
  List<Task> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage extends StateNotifier<List<Task>>
    implements LocalStorage {
  late Box<Task> _taskBox;

  HiveLocalStorage() : super([]) {
    _taskBox = Hive.box<Task>('tasks');
    List<Task>? _allTask = _taskBox.values.toList();

    if (_allTask.isNotEmpty) {
      _allTask.sort((Task a, Task b) => b.createdAt.compareTo(a.createdAt));
    }
    state = _allTask;
  }

  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
    state = [task, ...state];
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    state = state.where((element) => element.id != task.id).toList();
    await _taskBox.delete(task.id);
    return true;
  }

  @override
  List<Task> getAllTask() {
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();

    if (_allTask.isNotEmpty) {
      _allTask.sort((Task a, Task b) => b.createdAt.compareTo(a.createdAt));
    }
    state = _allTask;
    return _allTask;
  }

  @override
  Task? getTask({required String id}) {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    state = [
      for (var item in state)
        if (item.id == task.id)
          Task(
              id: task.id,
              name: task.name,
              createdAt: task.createdAt,
              isCompleted: task.isCompleted)
        else
          item,
    ];

    await task.save();

    return task;
  }
}

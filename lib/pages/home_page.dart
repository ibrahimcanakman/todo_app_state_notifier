import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../all_provider.dart';
import '../helper/translation_helper.dart';
import '../models/task_model.dart';
import '../widgets/custom_search_delegate.dart';
import '../widgets/task_list_item.dart';


class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> _allTasks = ref.watch(todosProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet(context, ref);
          },
          child: const Text(
            'title',
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage(context, ref);
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet(context, ref);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                //_allTasks = ref.watch(todosProvider);
                var _oankiListeElemani = _allTasks[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text('remove_task').tr()
                    ],
                  ),
                  key: Key(_oankiListeElemani.id),
                  onDismissed: (direction) async {
                    _allTasks.removeAt(index);
                    await ref
                        .read(todosProvider.notifier)
                        .deleteTask(task: _oankiListeElemani);
                  },
                  child: TaskItem(task: _oankiListeElemani),
                );
              },
              itemCount: _allTasks.length,
            )
          : Center(
              child: const Text('empty_task_list').tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'add_task'.tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(context,
                      locale: TranslationHelper.getDeviceLanguage(context),
                      showSecondsColumn: false, onConfirm: (time) async {
                    var yeniEklenecekGorev =
                        Task.create(name: value, createdAt: time);

                    //_allTasks.insert(0, yeniEklenecekGorev);
                    await ref
                        .read(todosProvider.notifier)
                        .addTask(task: yeniEklenecekGorev);
                    //_getAllTaskFromDb(ref);
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }


  void _showSearchPage(BuildContext context, WidgetRef ref) async {
    await showSearch(context: context, delegate: CustomSearchDelegate());
  }
}
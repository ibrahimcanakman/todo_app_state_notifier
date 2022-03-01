import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../all_provider.dart';
import '../models/task_model.dart';
import 'task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        List<Task> allTasks = ref.watch(todosProvider);

        List<Task> filteredList = allTasks
            .where((gorev) =>
                gorev.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return filteredList.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var _oankiListeElemani = filteredList[index];

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
                      filteredList.removeAt(index);
                      await ref
                          .read(todosProvider.notifier)
                          .deleteTask(task: _oankiListeElemani);
                    },
                    child: TaskItem(task: _oankiListeElemani),
                  );
                },
                itemCount: filteredList.length,
              )
            : Center(
                child: const Text('search_not_found').tr(),
              );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

import 'package:Todoapp/data/local_storage.dart';
import 'package:Todoapp/main.dart';
import 'package:Todoapp/models/task_model.dart';
import 'package:Todoapp/witget/task_list_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query.isEmpty ? null : query = "";
        },
        icon: const Icon(Icons.clear),
      )
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
    List<Task> filteredList = allTasks
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredList.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var oankiListeElemani = filteredList[index];
              return Dismissible(
                background: Row(
                  children: [
                    const Icon(Icons.delete),
                    const Text("remove_task").tr()
                  ],
                ),
                key: Key(oankiListeElemani.id.toString()),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>()
                      .deleteTask(task: oankiListeElemani);
                },
                child: TaskItem(task: oankiListeElemani),
              );
            },
            itemCount: filteredList.length,
          )
        : Center(
            child: const Text("search_not_found").tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

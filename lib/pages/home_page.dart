import 'package:Todoapp/data/local_storage.dart';
import 'package:Todoapp/main.dart';
import 'package:Todoapp/models/task_model.dart';
import 'package:Todoapp/witget/custom_search_delegate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../witget/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet(context);
          },
          child: const Text(
            "title",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var oankiListeElemani = _allTasks[index];
                return Dismissible(
                  background: const Row(
                    children: [
                      Icon(Icons.delete),
                      Text("remove_task"),
                    ],
                  ),
                  key: Key(oankiListeElemani.id.toString()),
                  onDismissed: (direction) async {
                    _allTasks.removeAt(index);
                    await _localStorage.deleteTask(task: oankiListeElemani);
                    setState(() {});
                  },
                  child: TaskItem(task: oankiListeElemani),
                );
              },
              itemCount: _allTasks.length,
            )
          : Center(
              child: const Text("empty_task_list").tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
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
              style: const TextStyle(fontSize: 22),
              decoration: InputDecoration(
                hintText: "add_task".tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  Navigator.of(context).pop();
                  var time = DateTime.now();
                  var yeniEklenecekGorev =
                      Task.create(name: value, createdAt: time);
                  _allTasks.insert(0, yeniEklenecekGorev);
                  await _localStorage.addTask(task: yeniEklenecekGorev);
                  setState(() {});
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTasks();
    setState(() {});
  }

  void _showSearchPage() {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(allTasks: _allTasks),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Task {
  final String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  void addTask(String title) {
    _tasks.add(Task(title: title));
    notifyListeners();
  }
  void toggleTaskStatus(Task task) {
    task.isDone = !task.isDone;
    notifyListeners();
  }
  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}

class TodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Simple To-Do List')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => taskProvider.deleteTask(task),
                  ),
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (value) => taskProvider.toggleTaskStatus(task),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final title = _controller.text;
                    if (title.isNotEmpty) {
                      taskProvider.addTask(title);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Simple To-Do App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: TodoScreen(),
      ),
    ),
  );
}
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/tasks_list_item.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({Key? key}) : super(key: key);

  @override
  State<TasksListPage> createState() => _TasksListPage();
}

class _TasksListPage extends State<TasksListPage> {

  TextEditingController taskController = TextEditingController();
  List<Task> taskList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Estudar matemática',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in taskList)
                        TasksListItem(task: task, deleteTask: deleteTask),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Você possui ${taskList.length} tarefas recentes.'),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          taskList.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.all(20),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Limpar Tudo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTask() {
    String text = taskController.text;
    setState(() {
      Task newTask = Task(title: text, dateTime: DateTime.now());
      taskList.add(newTask);
    });
    taskController.clear();
  }

  void deleteTask(Task task) {
    setState(() {
      taskList.remove(task);
    });
  }

}

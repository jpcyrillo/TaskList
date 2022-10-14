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
  Task? deletedTask;
  int? deletedTaskPosition;

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
                      onPressed: () {
                        taskController.text.isNotEmpty ? addTask() : null;
                      },
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
                        taskList.isNotEmpty ? showDeletAllTasksDialogue() : null;
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
    deletedTask = task;
    deletedTaskPosition = taskList.indexOf(task);

    setState(() {
      taskList.remove(task);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa "${task.title}" foi removida com sucesso!'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          setState(() {
            taskList.insert(deletedTaskPosition!, deletedTask!);
          });
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeletAllTasksDialogue() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Limpar tudo?'),
              content:
                  const Text('Você tem certeza que deseja apagar todas as tarefas?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      taskList.clear();
                    });
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Limpar tudo'),
                ),
              ],
            ));
  }
}

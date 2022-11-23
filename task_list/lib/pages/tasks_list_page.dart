import 'package:flutter/material.dart';
import 'package:task_list/repositories/tasks_repository.dart';
import '../models/task.dart';
import '../widgets/tasks_list_item.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({Key? key}) : super(key: key);

  @override
  State<TasksListPage> createState() => _TasksListPage();
}

class _TasksListPage extends State<TasksListPage> {
  final TextEditingController taskController = TextEditingController();
  final TasksRepository tasksRepository = TasksRepository();
  List<Task> taskList = [];
  List<Task>? deletedTaskList;
  Task? deletedTask;
  int? deletedTaskPosition;
  String? errorText;

  @override
  void initState() {
    super.initState();
    tasksRepository.getTaskList().then((value) {
      setState(() {
        taskList = value;
      });
    });
  }

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
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex. Estudar matemática',
                          errorText: errorText,
                          focusedBorder: const OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => addTask(),
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
                    taskList.length == 1 ?
                      const Text('Você possui 1 tarefa recente.') :
                      Text('Você possui ${taskList.length} tarefas recentes.'),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        taskList.isNotEmpty
                            ? showDeleteAllTasksDialogue()
                            : null;
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

    if (taskController.text.isEmpty) {
      setState(() {
        errorText = 'O título não pode ser vazio!';
      });
      return;
    }

    setState(() {
      Task newTask = Task(title: text, dateTime: DateTime.now());
      taskList.add(newTask);
      errorText = null;
    });
    taskController.clear();
    tasksRepository.saveTaskList(taskList);
  }

  void deleteTask(Task task) {
    deletedTask = task;
    deletedTaskPosition = taskList.indexOf(task);

    setState(() {
      taskList.remove(task);
    });

    tasksRepository.saveTaskList(taskList);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa "${task.title}" foi removida com sucesso!'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          setState(() {
            taskList.insert(deletedTaskPosition!, deletedTask!);
          });
          tasksRepository.saveTaskList(taskList);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void deleteAllTasks() {
    setState(() {
      taskList.clear();
    });
    tasksRepository.saveTaskList(taskList);
  }
  void showDeleteAllTasksDialogue() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Limpar tudo?'),
              content: const Text(
                  'Você tem certeza que deseja apagar todas as tarefas?'),
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
                    deleteAllTasks();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Limpar tudo'),
                ),
              ],
            ));
  }
}

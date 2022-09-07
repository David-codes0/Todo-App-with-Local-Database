import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sql_todo/database/todo_database.dart';
import 'package:sql_todo/models/todo.dart';
import 'dart:developer' as devtools;
import 'package:sql_todo/services/todo_service.dart';
import 'package:sql_todo/services/user_service.dart';
import 'package:sql_todo/widget/dialogs.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TextEditingController todoController;

  @override
  void initState() {
    super.initState();
    todoController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    todoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text('Create a  new todo '),
                  content: TextField(
                    controller: todoController,
                    decoration: const InputDecoration(
                      hintText: 'Please enter todo',
                    ),
                  ),
                  backgroundColor: Colors.white,
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (todoController.text.isEmpty) {
                          snackBar(context, 'Please enter Todo list');
                        } else {
                          String username =
                              context.read<UserService>().currentUser.username;
                          Todo todo = Todo(
                            title: todoController.text.trim(),
                            created: DateTime.now(),
                            username: username,
                          );
                          if (context
                              .read<TodoService>()
                              .todos
                              .contains(todo)) {
                            snackBar(context, 'Duplicate Please try again');
                          } else {
                            String result = await context
                                .read<TodoService>()
                                .createTodo(todo);
                            if (result == 'OK') {
                              snackBar(context, 'New Todo Succefully Created');
                              todoController.text = '';
                            } else {
                              snackBar(context, result);
                            }

                            devtools.log(username);
                            devtools.log(result);
                            final getallUser =
                                await TodoDatabase.instance.getAllUsers();
                               devtools.log(getallUser.toString());
                            
                            final todosList =
                                await TodoDatabase.instance.getTodos('David');
                              devtools.log(todosList.toString());

                           

                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<UserService>(
              builder: (context, value, child) {
                return Text('${value.currentUser.name}\'s Todolist',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ));
              },
            ),
            Expanded(
              child: Consumer<TodoService>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: value.todos.length,
                    itemBuilder: (context, index) {
                      return TodoCard(todo: value.todos[index]);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  const TodoCard({Key? key, required this.todo}) : super(key: key);
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
      child: Card(
        elevation: 10,
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  final result =
                      await context.read<TodoService>().deleteTodo(todo);
                  if (result == 'OK') {
                    
                    snackBar(context, 'delete Successful');
                  } else {
                    snackBar(context, result);
                  }
                  devtools.log(result);

                  final todosList =
                      await TodoDatabase.instance.getTodos('David');
                  devtools.log(todosList.toString());
                },
                backgroundColor: const Color.fromARGB(255, 241, 120, 211),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: CheckboxListTile(
            checkColor: Colors.white,
            value: todo.done,
            activeColor: const Color.fromARGB(255, 255, 41, 166),
            onChanged: (value) async {
              String result =
                  await context.read<TodoService>().toggleTodoDone(todo);
              if (result != 'OK') {
                snackBar(context, result);
              }
            },
            title: Text(
              todo.title,
            ),
            subtitle: Text(
                '${todo.created.day}/${todo.created.month}/${todo.created.year}'),
          ),
        ),
      ),
    );
  }
}

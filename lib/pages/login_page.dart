import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sql_todo/routes/routes.dart';
import 'package:sql_todo/services/todo_service.dart';
import 'package:sql_todo/services/user_service.dart';

import 'package:sql_todo/widget/app_textfield.dart';
import 'package:sql_todo/widget/dialogs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController usernameController;
  @override
  late bool mounted;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome User',
              style: TextStyle(fontSize: 50, color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            AppTextField(
              controller: usernameController,
              labelText: 'Please enter your username', color: Colors.white,
              // color: Colors.white,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 218, 90, 200),
              ),
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (usernameController.text.isEmpty) {
                  snackBar(context, 'Please Enter username');
                } else {
                  String result = await context
                      .read<UserService>()
                      .getUser(usernameController.text.trim());
                  if (result != 'OK') {
                    
                    if (!mounted) {}
                    snackBar(context, result);
                  } else {
                   
                    
                    String username = context.read<UserService>().currentUser.username;
                    // ignore: use_build_context_synchronously
                    context.read<TodoService>().getTodos(username);
                    Navigator.of(context).pushNamed(RoutesManager.todoPage);
                  }
                }
              },
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RoutesManager.registerPage);
              },
              child: const Text(
                'Register new user',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

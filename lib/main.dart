import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_todo/routes/routes.dart';
import 'package:sql_todo/services/todo_service.dart';
import 'package:sql_todo/services/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserService(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoService(),
        )
      ],
      child: Consumer<UserService>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: const TextTheme(
                headline1: TextStyle(color: Colors.white),
              ),
            ),
            initialRoute: RoutesManager.loginPage,
            onGenerateRoute: RoutesManager.gettingRoute,
          );
        },
      ),
    );
  }
}

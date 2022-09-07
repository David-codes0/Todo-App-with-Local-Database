import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql_todo/pages/login_page.dart';
import 'package:sql_todo/pages/register_page.dart';
import 'package:sql_todo/pages/todo_page.dart';
import 'package:sql_todo/widget/backgroungpage.dart';

class RoutesManager{
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String todoPage = '/todoPage';

 static Route<dynamic> gettingRoute(RouteSettings settings){
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => const BackgroundPage(child:  LoginPage()),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => const BackgroundPage(child: RegisterPage()),
        );

      case todoPage:
        return MaterialPageRoute(
          builder: (context) => const BackgroundPage(child: TodoPage()),
        );

      default:
        throw const FormatException('Route not found! Check routes again!');
    }

 }
 }
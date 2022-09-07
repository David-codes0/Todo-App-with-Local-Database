import 'package:flutter/cupertino.dart';

const String todoTable = 'todo';

class TodoFields {
  static const String username = 'username';
  static const String title = 'title';
  static const String done = 'done';
  static const String created = 'created';
  static final List<String> allFields = [username, title, done, created];
}

class Todo {
  final String username;
  final String title;
  bool done;
  final DateTime created;

  Todo({
    required this.username,
    required this.title,
     this.done = false,
    required this.created,
   
  });

  Map<String, Object?> toJson() {
    // from a Todo object to a json
    return {
      TodoFields.username: username,
      TodoFields.title: title,
      TodoFields.done: done ? 1 : 0,
      TodoFields.created:
          created.toIso8601String(), // because sqflite doesnt accept it
    };
  }

  static Todo fromJson(Map<String, Object?> json) {
    // from sqflite json  to a TOdo object
    return Todo(
        username: json[TodoFields.username] as String,
        title: json[TodoFields.title] as String,
        done: json[TodoFields.done] == 1 ? true : false,
        created: DateTime.parse(json[TodoFields.created] as String),);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  bool operator ==(covariant Todo todo) {
    return (username == todo.username) &&
        (title.toUpperCase().compareTo(todo.title.toUpperCase())) == 0;
  }

  @override
  int get hashCode {
    return hashValues(username, title);
  }

  @override
  String toString() {
    return '$username $title $created $done';
  }
}


// const String todoTable = 'todo';

// class TodoFields {
//   static const String username = 'username';
//   static const String title = 'title';
//   static const String done = 'done';
//   static const String created = 'created';
//   static final List<String> allFields = [username, title, done, created];
// }

// class Todo {
//   final String username;
//   final String title;
//   bool done;
//   final DateTime created;

//   Todo({
//     required this.username,
//     required this.title,
//     this.done = false,
//     required this.created,
//   });

//   Map<String, Object?> toJson() => {
//         TodoFields.username: username,
//         TodoFields.title: title,
//         TodoFields.done: done ? 1 : 0,
//         TodoFields.created: created.toIso8601String(),
//       };

//   static Todo fromJson(Map<String, Object?> json) => Todo(
//         username: json[TodoFields.username] as String,
//         title: json[TodoFields.title] as String,
//         done: json[TodoFields.done] == 1 ? true : false,
//         created: DateTime.parse(json[TodoFields.created] as String),
//       );

//   @override
//   bool operator ==(covariant Todo todo) {
//     return (username == todo.username) &&
//         (title.toUpperCase().compareTo(todo.title.toUpperCase()) == 0);
//   }

//   @override
//   int get hashCode {
//     return hashValues(username, title);
//   }

//   @override
//   String toString() {
//     return '$username $title $created $done';
//   }
// }

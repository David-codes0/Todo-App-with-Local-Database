import 'package:flutter/material.dart';

class BackgroundPage extends StatelessWidget {
  const BackgroundPage({Key? key, required this.child}) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
            colors: [
              Color.fromARGB(255, 255, 41, 166),
              Color.fromARGB(255, 250, 199, 164),
              Color.fromARGB(255, 255, 41, 166),
            ],
          ),
        ),
        child: child);
  }
}

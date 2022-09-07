import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.color,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final Color color;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        keyboardType: TextInputType.text,
        controller: widget.controller,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: widget.color),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: widget.color,
              width: 2,
            ),
          ),
          labelText: widget.labelText,
        ),
      ),
    );
  }
}

// class AppTextField extends StatelessWidget {
//   const AppTextField({
//     Key? key,
//     required this.controller,
//     required this.labelText,
//   }) : super(key: key);

//   final TextEditingController controller;
//   final String labelText;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:
//           const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 20),
//       child: TextField(
//         style: TextStyle(color: Colors.white),
//         cursorColor: Colors.white,
//         controller: controller,
//         keyboardType: TextInputType.text,
//         decoration: InputDecoration(
//           labelStyle: TextStyle(color: Colors.white),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 2,
//               color: Colors.white,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 1,
//               color: Colors.grey,
//             ),
//           ),
//           labelText: labelText,
//         ),
//       ),
//     );
//   }
// }


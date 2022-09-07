import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_todo/models/user.dart';

import 'package:sql_todo/services/user_service.dart';
import 'package:sql_todo/widget/app_textfield.dart';
import 'package:sql_todo/widget/dialogs.dart';
import 'dart:developer' as devtools;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController usernameController;
  late TextEditingController nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    nameController.dispose();
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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Register User',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                Focus(
                  onFocusChange: (value) async {
                    if (!value) {
                      await context
                          .read<UserService>()
                          .checkIfUserExist(usernameController.text.trim());
                    }
                  },
                  child: Consumer<UserService>(
                    builder: (context, value, child) {
                      return value.userCreate
                          ? AppTextField(
                              usernameController: usernameController,
                              labelText: 'Please enter your username',
                              color: Colors.red,
                            )
                          : AppTextField(
                              usernameController: usernameController,
                              labelText: 'Please enter your username',
                              color: Colors.white,
                            );
                    },
                  ),
                ),
                Consumer<UserService>(
                  builder: (context, value, child) {
                    return value.userCreate
                        ? const Text(
                            'username already exist ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 0, 128),
                            ),
                          )
                        : Container();
                  },
                ),
                AppTextField(
              controller: nameController,
                  labelText: 'Please enter your name',
                  color: Colors.white,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 218, 90, 200),
                  ),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (usernameController.text.isEmpty ||
                        nameController.text.isEmpty) {
                      snackBar(context, 'Please Enter all Fields');
                    } else {
                      User user = User(
                        name: nameController.text.trim(),
                        username: usernameController.text.trim(),
                      );
                      String result =
                          await context.read<UserService>().createUser(user);

                      if (result == 'OK') {
                        snackBar(context, 'Successfully Created');
                        Navigator.pop(context);
                      } else {
                        // ignore: use_build_context_synchronously
                        snackBar(context, result);
                        devtools.log(result);
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
            Consumer<UserService>(
              builder: (context, value, child) {
                return value.busyCreate
                    ? const AppProgressIndicator()
                    : Container();
              },
            )
          ],
        ),
      ),
    );
  }
}

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(0.5),
      child: const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        ),
      ),
    );
  }
}
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({Key? key}) : super(key: key);

//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   late TextEditingController usernameController;
//   late TextEditingController nameController;

//   @override
//   void initState() {
//     super.initState();
//     usernameController = TextEditingController();
//     nameController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     usernameController.dispose();
//     nameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.purple, Colors.blue],
//               ),
//             ),
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(bottom: 30.0),
//                       child: Text(
//                         'Register User',
//                         style: TextStyle(
//                             fontSize: 46,
//                             fontWeight: FontWeight.w200,
//                             color: Colors.white),
//                       ),
//                     ),
//                     Focus(
//                       onFocusChange: (value) async {
//                         if (!value) {
//                           String result = await context
//                               .read<UserService>()
//                               .checkIfUserExists(
//                                   usernameController.text.trim());
//                           if (result == 'OK') {
//                             context.read<UserService>().userExists = true;
//                           } else {
//                             context.read<UserService>().userExists = false;
//                             if (!result.contains(
//                                 'The user does not exist in the database. Please register first.')) {
//                               snackBar(context, result);
                            
//                             }
                           
//                           }
//                         }
//                       },
//                       child: AppTextField(
//                         controller: usernameController,
//                         labelText: 'Please enter your username',
//                       ),
//                     ),
//                     Selector<UserService, bool>(
//                       selector: (context, value) => value.userExists,
//                       builder: (context, value, child) {
//                         return value
//                             ? const Text(
//                                 'username exists, please choose another',
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.w800),
//                               )
//                             : Container();
//                       },
//                     ),
//                     AppTextField(
//                       controller: nameController,
//                       labelText: 'Please enter your name',
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(primary: Colors.purple),
//                         onPressed: () async {
//                           FocusManager.instance.primaryFocus?.unfocus();
//                           if (usernameController.text.isEmpty ||
//                               nameController.text.isEmpty) {
//                             snackBar(
//                               context,
//                               'Please enter all fields!',
//                             );
//                           } else {
//                             User user = User(
//                               username: usernameController.text.trim(),
//                               name: nameController.text.trim(),
//                             );
//                             String result = await context
//                                 .read<UserService>()
//                                 .createUser(user);
//                             if (result != 'OK') {
//                               snackBar(context, result);
//                             } else {
//                               snackBar(
//                                   context, 'New user successfully created!');
//                               Navigator.pop(context);
//                             }
//                           }
//                         },
//                         child: const Text('Register'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 20,
//             top: 30,
//             child: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(
//                 Icons.arrow_back,
//                 size: 30,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Selector<UserService, bool>(
//             selector: (context, value) => value.busyCreate,
//             builder: (context, value, child) {
//               return value ? const AppProgressIndicator() : Container();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppProgressIndicator extends StatelessWidget {
//   const AppProgressIndicator({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       color: Colors.white.withOpacity(0.5),
//       child: Center(
//         child: Container(
//           height: 20,
//           width: 20,
//           child: const CircularProgressIndicator(
//             color: Colors.purple,
//           ),
//         ),
//       ),
//     );
//   }
// }

// void appProgressIndicator(BuildContext context) {
//   showDialog(
//       context: context, builder: (context) => const AppProgressIndicator());
// }

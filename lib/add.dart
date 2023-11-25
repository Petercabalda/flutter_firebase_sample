import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_firebase_sample/users.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  late Future<List<Users>> fetchUserListAcc;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();
  Future<Users>? _futureUser;
  @override
  void initState() {
    super.initState();
  }

  Future createUser(
    String email,
    String first_name,
    String last_name,
    String avatar,
  ) async {
    final response = await http.post(
      Uri.parse('https://sampleapicall.ebsu-escholar.com/add.php'),
      body: {
        'email': email,
        'first_name': first_name,
        'last_name': last_name,
        'avatar': avatar,
      },
    );

    var data = jsonDecode(response.body);

    await Future.delayed(
      const Duration(seconds: 1),
    );
    if (!mounted) return;

    if (data == "success") {
      clearFields();
      showAlertDialog(
        context,
        "Success",
        "New Data Created",
      );
    } else {
      showAlertDialog(
        context,
        "Error",
        "Failed to create user",
      );
      throw Exception('Failed to create user.');
    }
  }

  void showAlertDialog(
    BuildContext context,
    String title,
    String msg,
  ) {
    Widget continueButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("OK"),
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  txtBoxStyle(label, iconVal) => InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(iconVal),
      );

  btnStyle(color) => ElevatedButton.styleFrom(
        primary: color,
        minimumSize: const Size.fromHeight(50),
      );

  clearFields() {
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    avatarController.clear();
  }

  buildAddUserField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: emailController,
            decoration: txtBoxStyle('Enter email ', Icons.email),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: firstNameController,
            decoration: txtBoxStyle('Enter firstname ', Icons.person_add),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: lastNameController,
            decoration: txtBoxStyle('Enter lastname ', Icons.person),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: avatarController,
            decoration: txtBoxStyle('Enter image avatar ', Icons.photo),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: btnStyle(Colors.blue),
            onPressed: () {
              setState(() {
                createUser(
                  emailController.text,
                  firstNameController.text,
                  lastNameController.text,
                  avatarController.text,
                );
              });
            },
            child: const Text('Create Data'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Data from Internet'),
      ),
      body: Center(
        child: buildAddUserField(),
      ),
    );
  }
}

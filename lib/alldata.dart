import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_sample/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Users>> fetchUserList() async {
  final response = await http.get(
    Uri.parse(
      'https://reqres.in/api/users',
    ),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["data"];
    return data.map((data) => Users.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load user data');
  }
}

buildColumn(Users fetchList, BuildContext context) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(fetchList.avatar),
      ),
      title: Text('${fetchList.first_name} ${fetchList.last_name}'),
      subtitle: Text(fetchList.email),
    ),
  );
}

buildList(BuildContext context, List<Users> fetchList) {
  return ListView.builder(
    itemCount: fetchList.length,
    itemBuilder: (context, int currentIndex) {
      return buildColumn(fetchList[currentIndex], context);
    },
  );
}

class AllData extends StatefulWidget {
  const AllData({super.key});

  @override
  State<AllData> createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {
  late Future<List<Users>> fetchUserListAcc;

  @override
  void initState() {
    fetchUserListAcc = fetchUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetching data from Internet'),
      ),
      body: Center(
        child: FutureBuilder<List<Users>>(
          future: fetchUserListAcc,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Users> fetchData = snapshot.data!;
              return buildList(context, fetchData);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

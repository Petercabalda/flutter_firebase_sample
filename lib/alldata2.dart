import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_firebase_sample/users.dart';

Future<List<Users>> fetchUserList() async {
  final response = await http.get(
    Uri.parse(
      'https://sampleapicall.ebsu-escholar.com/alldata.php',
    ),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(
      response.body,
    );
    return data.map((data) => Users.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load user data');
  }
}

class AllData2 extends StatefulWidget {
  const AllData2({super.key});

  @override
  State<AllData2> createState() => _AllData2State();
}

class _AllData2State extends State<AllData2> {
  late Future<List<Users>> fetchUserListAcc;
  @override
  void initState() {
    fetchUserListAcc = fetchUserList();
    super.initState();
  }

  buildList(BuildContext context, List<Users> fetchList) {
    return ListView.builder(
      itemCount: fetchList.length,
      itemBuilder: (context, int currentIndex) {
        return buildColumn(fetchList[currentIndex], context);
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetching Data from Internet'),
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

import 'package:flutter/material.dart';

import 'package:flutter_firebase_sample/albums.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_firebase_sample/users.dart';

Future<List<Album>> fetchUserList() async {
  final response = await http.get(
    Uri.parse(
      'https://jsonplaceholder.typicode.com/albums',
    ),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(
      response.body,
    );
    return data.map((data) => Album.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load user data');
  }
}

class AllData1 extends StatefulWidget {
  const AllData1({super.key});

  @override
  State<AllData1> createState() => _AllData1State();
}

class _AllData1State extends State<AllData1> {
  late Future<List<Album>> fetchAlbumListAcc;

  @override
  void initState() {
    fetchAlbumListAcc = fetchUserList();
    super.initState();
  }

  buildList(BuildContext context, List<Album> fetchList) {
    return ListView.builder(
      itemCount: fetchList.length,
      itemBuilder: (context, int currentIndex) {
        return buildColumn(fetchList[currentIndex], context);
      },
    );
  }

  buildColumn(Album fetchList, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(fetchList.title),
        subtitle: Text(fetchList.id.toString()),
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
        child: FutureBuilder<List<Album>>(
          future: fetchAlbumListAcc,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Album> fetchData = snapshot.data!;
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

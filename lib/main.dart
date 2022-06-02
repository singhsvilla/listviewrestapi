import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

Future<List<Data>> fetchData() async {
  final response =
  await
  http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums')
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) =>
        Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}


class Data {
  final int userId;
  final int id;
  final String title;
  Data({this.userId = 0, this.id = 0, this.title = ''});
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main()=>runApp(myapp());

class myapp extends StatefulWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  _myappState createState() => _myappState();
}

class _myappState extends State<myapp> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }
    Widget build(BuildContext context) {
      return MaterialApp(home: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Center(
          child: FutureBuilder<List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data>? data = snapshot.data;
                return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(data[index].title),
                          onTap: ()
                          {
                            
                          },
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
// By default show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      )
      );
    }
  }


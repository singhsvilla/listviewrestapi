import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

Future<List<Data>> fetchData() async {
  final response =  await   http.get(Uri.parse('https://erevenuecourt.jharkhand.gov.in/api/PendingCaseReport'));
  print (response.statusCode);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return jsonResponse.map((data) =>     Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}


class Data {
  final String district;
  final String total;
  final String disposed;
  final String pending;
  final String dcode;

  Data({this.district='', this.total='', this.disposed='', this.pending='', this.dcode=''});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      district: json['district'],
      total: json['total'],
      disposed: json['disposed'],
      pending: json['pending'],
      dcode: json['dcode'],
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
                          title: Text(data[index].district),
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


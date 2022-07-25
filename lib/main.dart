import 'dart:convert';
import 'package:act_flutter/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    late Future<List<Post>> _listadoPosts;

  Future<List<Post>> getPosts() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    List<Post> posts = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData) {
        posts
            .add(Post(item["id"], item["title"], item["body"]));
      }

      return posts;
    } else {
      throw Exception("No se puede conectar");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoPosts = getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumo API',
      home: Scaffold(
        backgroundColor: Colors.black12,
          appBar: AppBar(
            title: Text('Consumo de API Posts - Darwin Freire'),
            backgroundColor: Colors.indigo,
          ),
          body: FutureBuilder(
              future: _listadoPosts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(children: _listaPosts(snapshot.data));
                } else if (snapshot.hasError) {
                  return Text("Error al consultar la API");
                }
                return Center(child: CircularProgressIndicator());
              })),
    );
  }

  List<Widget> _listaPosts(data) {
    List<Widget> posts = [];
    for (var item in data) {
      posts.add(Card(
          child: Column(
            children: [
              Row(
                children: [
                  Text("Título: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(item.title)
                ],
              ),
              Row(
                children: [
                  Text("Cuerpo: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(item.body)
                ],
              ),
            ],
          )));
    }
    return posts;
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<NewsData> data = [];

  Future<String> _getData() async {
    print("Loading.....");
    var url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=th&category=business&apiKey=eb1a72ebd0874af8bb85b76fb4583161');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      for (var article in jsonData['articles']) {
        NewsData news = NewsData(
          article['title'],
          article['description'],
          article['url'],
          article['urlToImage'],
        );
        data.add(news);
      }
    }
    return response.statusCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (context, snapshort) {
          if (snapshort.hasData) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Text("${data[index].title}");
                });
          } else {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ]),
            );
          }
        },
      ),
    );
  }
}

class NewsData {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  NewsData(this.title, this.description, this.url, this.urlToImage);
}

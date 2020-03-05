import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp2/unsplash_photo.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        UnsplashPhoto.routeName: (context) => UnsplashPhoto(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Article>> getData() async {
    List<Article> list;
    String link =
        'https://api.unsplash.com/photos/?client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0';
    var res = await http.get(link);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      list = data.map<Article>((json) => Article.fromJson(json)).toList();
    }
    return list;
  }

  Widget listViewWidget(List<Article> article) {
    TextStyle textStyle = new TextStyle(color: Colors.white, fontSize: 18);

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
        itemCount: article.length,
        itemBuilder: (context, position) {
          return GridTile(
            child: GestureDetector(
              child:
                  Image.network('${article[position].url}', fit: BoxFit.cover),
              onTap: () {
                Navigator.pushNamed(context, UnsplashPhoto.routeName,
                    arguments: article[position].fullUrl);
              },
            ),
            footer: Container(
              color: Colors.black45,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text('Author: ' + article[position].username,
                      textAlign: TextAlign.left, style: textStyle),
                  new Text(
                    'Description: ' + (article[position].description ?? ''),
                    textAlign: TextAlign.left,
                    style: textStyle,
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? listViewWidget(snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }));
  }
}

class Article {
  String url;
  String fullUrl;
  String username;
  String description;

  Article({
    this.url,
    this.fullUrl,
    this.description,
    this.username,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    print(json['urls']['full']);
    return Article(
        url: json['urls']['small'],
        fullUrl: json['urls']['regular'],
        description: json['alt_description'],
        username: json['user']['username']);
  }
}

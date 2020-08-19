import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<List<Post>> getData() async {
    http.Response response =
        await http.get('https://jsonplaceholder.typicode.com/posts');
    List<Post> posts;
    if (response.statusCode == 200) {
      Iterable decodedJson = jsonDecode(response.body);
      posts =
          List<Post>.from(decodedJson.map((x) => Post.fromJson(x))).toList();
    } else {
      print(response.statusCode);
    }
    return posts;
  }

  ListTile postListItem(int index, List<Post> posts, BuildContext context) {
    return ListTile(
      title: Text(posts[index].title),
      subtitle: Text(
        posts[index].body,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.caption,
      ),
      isThreeLine: true,
      trailing: Text(
        'Post ${posts[index].id}',
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Posts"),
        ),
        body: Center(
          child: FutureBuilder(
              future: getData(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                if (snapshot.data is List<Post>) {
                  List<Post> posts = snapshot.data;
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            postListItem(index, posts, context),
                            SizedBox(
                              height: 20.0,
                              child: Divider(
                                color: Colors.black,
                              ),
                            )
                          ],
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ));
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tribehired_frontend_test/api/api.dart';
import 'package:tribehired_frontend_test/model/post_model.dart';
import 'package:tribehired_frontend_test/post_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TribeHired Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEST'),
      ),
      body: FutureBuilder<List<PostModel>?>(
        future: Api.getAllPosts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PostModel>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final int id = snapshot.data![index].id!;
                final String title = snapshot.data![index].title!;
                final String body = snapshot.data![index].body!;
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PostPage(id: id)));
                    },
                    title: Text(title),
                    subtitle: Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}


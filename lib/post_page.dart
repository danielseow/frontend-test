import 'package:flutter/material.dart';
import 'package:tribehired_frontend_test/api/api.dart';
import 'package:tribehired_frontend_test/model/comment_model.dart';
import 'package:tribehired_frontend_test/model/post_model.dart';

class PostPage extends StatelessWidget {
  final int id;
  const PostPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('POST'),
      ),
      body: FutureBuilder(
        future: Future.wait([Api.getOnePost(id), Api.getComments(id)]),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              PostModel? postModel = snapshot.data[0];
              if (postModel == null) {
                return const Text('Error');
              }
              List<CommentModel> commentModel = snapshot.data[1] ?? [];
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                postModel.title!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(postModel.body!),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 2),
                      CommentsListView(
                        commentModel: commentModel,
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Error Occurs');
            } else {
              return const SizedBox.shrink();
            }
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class CommentsListView extends StatefulWidget {
  final List<CommentModel> commentModel;
  const CommentsListView({Key? key, required this.commentModel}) : super(key: key);

  @override
  State<CommentsListView> createState() => _CommentsListViewState();
}

class _CommentsListViewState extends State<CommentsListView> {
  late List<CommentModel> commentModel;
  List<String> items = ['Name', 'Email', 'Body'];
  String dropdownValue = 'Name';
  @override
  void initState() {
    super.initState();

    commentModel = widget.commentModel;
  }

  void searchComments(String value) {
    final suggestions = widget.commentModel.where((comment) {
      var searchComment;
      if (dropdownValue == 'Name') {
        searchComment = comment.name!.toLowerCase();
      } else if (dropdownValue == 'Email') {
        searchComment = comment.email!.toLowerCase();
      } else if (dropdownValue == 'Body') {
        searchComment = comment.body!.toLowerCase();
      }

      final query = value.toLowerCase();
      return searchComment.contains(query);
    }).toList();
    setState(() {
      commentModel = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                ),
                onChanged: (value) => searchComments(value),
              ),
            ),
          ],
        ),
        const Text(
          'Comments:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: commentModel.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentModel[index].name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(commentModel[index].email!),
                    const SizedBox(height: 10),
                    Text(commentModel[index].body!),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

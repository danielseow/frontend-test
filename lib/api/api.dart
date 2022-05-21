import 'dart:convert';
import 'dart:developer';

import 'package:tribehired_frontend_test/model/comment_model.dart';
import 'package:tribehired_frontend_test/model/post_model.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';
  static Future<List<PostModel>?> getAllPosts() async {
    try {
      var url = Uri.parse('$baseUrl/posts');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        // log(responseJson.toString());
        List<PostModel> model = (json.decode(response.body) as List)
            .map((i) => PostModel.fromJson(i))
            .toList();
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

   static Future<PostModel?> getOnePost(final int id) async {
    try {
      var url = Uri.parse('$baseUrl/posts/$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        // log(responseJson.toString());
        PostModel model =PostModel.fromJson(responseJson);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

     static Future<List<CommentModel>?> getComments(final int id) async {
    try {
      var url = Uri.parse('$baseUrl/comments?postId=$id');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        List<CommentModel> model = (responseJson as List)
            .map((i) => CommentModel.fromJson(i))
            .toList();
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

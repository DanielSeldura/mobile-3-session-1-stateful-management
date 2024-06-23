import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:state_change_demo/src/model/post.dart';

class SeeAllPost extends StatefulWidget {
  static const String route = 'see-all-post';
  static const String path = '/see-all-post';
  static const String name = 'See All Post';

  const SeeAllPost({super.key});

  @override
  State<SeeAllPost> createState() => _SeeAllPostState();
}

class _SeeAllPostState extends State<SeeAllPost> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SeeAllPost.name),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Post>>(
          future: posts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No posts found'));
            } else {
              List<Post> posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  Post post = posts[index];
                  return ListTile(
                    leading: Text('User: ${post.userId}'),
                    title: Text(post.title),
                    subtitle: Text(post.body),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<Post>> fetchData() async {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    List<Post> posts = jsonList.map((json) => Post.fromJson(json)).toList();
    return posts;
  } else {
    throw Exception('Failed to load posts');
  }
}

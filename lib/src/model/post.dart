class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post(
      {required this.userId,
      required this.id,
      required this.body,
      required this.title});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body']);
}

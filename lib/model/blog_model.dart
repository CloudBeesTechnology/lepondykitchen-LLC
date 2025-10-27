class BlogModel {
  final String? uid;
  final DateTime timeCreated;
  final String category;
  final String image;
  final String title;
  final String post;
  BlogModel({
    required this.category,
    required this.timeCreated,
    required this.title,
    required this.post,
    this.uid,
    required this.image,
  });
  Map<String, dynamic> toMap() {
    return {
      'timeCreated': timeCreated,
      'category': category,
      'title': title,
      'image': image,
      'post': post
    };
  }

  BlogModel.fromMap(data, this.uid)
      : category = data['category'],
        timeCreated = data['timeCreated'].toDate(),
        title = data['title'],
        post = data['post'],
        image = data['image'];
}

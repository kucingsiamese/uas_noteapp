class Note {
  String? id;
  String userId;
  String title;
  String content;

  Note({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
  });

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      userId: data['userId'],
      title: data['title'],
      content: data['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
    };
  }
}

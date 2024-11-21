class Note {
  String? id;
  String userId;
  String title;
  String content;
  int? color;

  Note({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.color,
  });

  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      userId: data['userId'],
      title: data['title'],
      content: data['content'],
      color: data['color'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'color': color,
    };
  }
}

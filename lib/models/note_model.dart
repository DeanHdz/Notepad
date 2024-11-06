class Note {
  final int? id;
  final int userId;
  final String title;
  final String description;

  Note({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
    );
  }
}

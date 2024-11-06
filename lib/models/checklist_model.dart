class Checklist {
  final int? id;
  final int userId;
  final String title;

  Checklist({
    this.id,
    required this.userId,
    required this.title,
  });

  // Convertir el objeto a un mapa para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
    };
  }

  // Crear un objeto Checklist a partir de un mapa (extraído de la base de datos)
  factory Checklist.fromMap(Map<String, dynamic> map) {
    return Checklist(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
    );
  }
}

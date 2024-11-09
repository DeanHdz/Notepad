class ChecklistItem {
  final int? id;
  int checklistId;
  String content;
  bool isDone;

  ChecklistItem({
    this.id,
    required this.checklistId,
    required this.content,
    this.isDone = false,
  });

  // Convertir el objeto a un mapa para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'checklist_id': checklistId,
      'content': content,
      'is_done': isDone ? 1 : 0,
    };
  }

  // Crear un objeto ChecklistItem a partir de un mapa (extraído de la base de datos)
  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'],
      checklistId: map['checklist_id'],
      content: map['content'],
      isDone: map['is_done'] == 1, // Convertir 1 a true, 0 a false
    );
  }
}

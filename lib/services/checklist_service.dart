import '../db/database_helper.dart';
import '../models/checklist_model.dart';
import '../models/checklist_item_model.dart';

class ChecklistService {
  /////// Métodos para interactuar con la tabla de checklists ///////

  // Método para crear un nuevo checklist
  Future<int> createChecklist(int userId, String title) async {
    Checklist checklist = Checklist(userId: userId, title: title);
    int checklistId = await DatabaseHelper().createChecklist(checklist);
    return checklistId;
  }

  // Método para obtener todos los checklists de un usuario
  Future<List<Checklist>> getChecklists(int userId) async {
    return await DatabaseHelper().getChecklistsByUser(userId);
  }

  // Método para actualizar un checklist
  Future<bool> updateChecklist(Checklist checklist) async {
    int result = await DatabaseHelper().updateChecklist(checklist);
    return result > 0;
  }

  // Método para eliminar un checklist
  Future<bool> deleteChecklist(int checklistId) async {
    int result = await DatabaseHelper().deleteChecklistById(checklistId);
    return result > 0;
  }

  /////// Métodos para interactuar con la tabla de checklist items ///////

  // Método para crear un nuevo item de checklist
  Future<int> createChecklistItem(int checklistId, String content) async {
    ChecklistItem checklistItem = ChecklistItem(
        checklistId: checklistId, content: content, isDone: false);
    int itemId = await DatabaseHelper().createChecklistItem(checklistItem);
    return itemId;
  }

  // Método para obtener un item de checklist por su id
  Future<ChecklistItem?> getChecklistItem(int itemId) async {
    return await DatabaseHelper().getChecklistItemById(itemId);
  }

  // Método para obtener todos los items de un checklist
  Future<List<ChecklistItem>> getChecklistItems(int checklistId) async {
    return await DatabaseHelper().getChecklistItemsByChecklistId(checklistId);
  }

  // Método para marcar un item como completado (cambiar el estado de isDone)
  Future<bool> updateChecklistItem(ChecklistItem checklistItem) async {
    int result = await DatabaseHelper().updateChecklistItem(checklistItem);
    return result > 0;
  }

  // Método para eliminar un item de checklist
  Future<bool> deleteChecklistItem(int itemId) async {
    int result = await DatabaseHelper().deleteChecklistItemById(itemId);
    return result > 0;
  }
}

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notepad/services/checklist_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notepad/models/checklist_model.dart' as ChecklistModel;
import 'package:notepad/models/checklist_item_model.dart' as ChecklistItemModel;
import 'package:notepad/components/task_list_item.dart';

class Checklist extends StatefulWidget {
  const Checklist({super.key});

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  List<ChecklistItemModel.ChecklistItem> tasks = [];
  List<ChecklistItemModel.ChecklistItem> tasksToDelete = [];
  bool isLoading = true; // Indicador de carga

  dynamic item; // Almacenar el argumento recibido (lista de tareas)

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recuperar el argumento de la ruta
    item = ModalRoute.of(context)?.settings.arguments;
    // Si el argumento no es nulo, cargar los datos de la nota
    if (item != null) {
      titleController.text = item.title;
      _loadChecklistItems();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadChecklistItems() async {
    setState(() {
      isLoading = true; // Muestra el indicador de carga
    });

    List<ChecklistItemModel.ChecklistItem> obtainedChecklistItems =
        await ChecklistService().getChecklistItems(item.id ?? 0);

    setState(() {
      tasks = obtainedChecklistItems;
      isLoading = false; // Oculta el indicador de carga
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B3B3B),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Listado de tareas',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveChecklist,
          ),
          item != null
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: deleteChecklist,
                )
              : const SizedBox(),
        ],
      ),
      backgroundColor: const Color(0xFF252525),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: titleController,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Título',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskListItem(
                    id: task.id ?? 0,
                    content: task.content,
                    isDone: task.isDone,
                    onChanged: (isSelected) {
                      setState(() {
                        task.isDone = isSelected;
                      });
                    },
                    onDelete: () {
                      setState(() {
                        removeTask(index);
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Nueva tarea',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      addTask();
                    } else {
                      Fluttertoast.showToast(
                        msg: 'La tarea no puede estar vacía',
                        backgroundColor: const Color(0xFF3B3B3B),
                        textColor: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Agregar una tarea a la lista
  Future<void> addTask() async {
    final String content = taskController.text;

    ChecklistItemModel.ChecklistItem task = ChecklistItemModel.ChecklistItem(
      id: 0,
      checklistId: item == null ? 0 : item.id,
      content: content,
      isDone: false,
    );
    setState(() {
      tasks.add(task);
    });
    taskController.clear();
  }

  void removeTask(int index) {
    setState(() {
      tasksToDelete.add(tasks[index]);
      tasks.removeAt(index);
    });
  }

  // Eliminar la nota
  void deleteChecklist() {
    AwesomeDialog(
      context: context,
      dialogBackgroundColor: const Color(0xFF1E1E1E),
      dialogType: DialogType.error,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      closeIcon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      title: 'Borrar lista',
      titleTextStyle: const TextStyle(color: Colors.white),
      desc: '¿Deseas eliminar la lista?',
      descTextStyle: const TextStyle(color: Colors.white),
      btnCancelText: 'No',
      btnCancelColor: const Color(0xFF3B3B3B),
      btnOkText: 'Si',
      btnOkColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        // Lógica para eliminar la lista
        ChecklistService().deleteChecklist(item.id);
        Fluttertoast.showToast(
          msg: 'Lista eliminada',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xFF3B3B3B),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      },
    ).show();
  }

  // Guardar la lista de tareas
  void saveChecklist() async {
    // Obtener el título de la lista
    final String title = titleController.text;
    //Obtener el id del usuario
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    //Validar que el título no esté vacío
    if (title.isEmpty) {
      // Mostrar toast de error
      Fluttertoast.showToast(
        msg: 'El título no puede estar vacío',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFF3B3B3B),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Guardar la lista
    if (item == null) {
      int checklistId = await ChecklistService().createChecklist(userId, title);
      // Actualizar la lista de tareas
      if (checklistId > 0) {
        for (ChecklistItemModel.ChecklistItem task in tasks) {
          task.checklistId = checklistId;
          if (task.id == 0) {
            await ChecklistService()
                .createChecklistItem(checklistId, task.content, task.isDone);
          } else {
            await ChecklistService().updateChecklistItem(task);
          }
        }
        for (ChecklistItemModel.ChecklistItem task in tasksToDelete) {
          if (task.id != 0) {
            await ChecklistService().deleteChecklistItem(task.id!);
          }
        }
        toastExito();
      } else {
        toastError();
      }
    } else {
      ChecklistModel.Checklist checklist = item as ChecklistModel.Checklist;
      int checklistId = item.id;
      checklist.title = title;
      await ChecklistService().updateChecklist(checklist)
          ? toastExito()
          : toastError();
      for (ChecklistItemModel.ChecklistItem task in tasks) {
        if (task.id == 0) {
          await ChecklistService()
              .createChecklistItem(checklistId, task.content, task.isDone);
        } else {
          await ChecklistService().updateChecklistItem(task);
        }
      }
      for (ChecklistItemModel.ChecklistItem task in tasksToDelete) {
        if (task.id != 0) {
          await ChecklistService().deleteChecklistItem(task.id!);
        }
      }
    }

    // Cerrar la pantalla de la lista de tareas
    Navigator.pop(context);
  }

  void toastExito() {
    Fluttertoast.showToast(
      msg: 'Lista guardada',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFF3B3B3B),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void toastError() {
    Fluttertoast.showToast(
      msg: 'Error al guardar la Lista',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFF3B3B3B),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}

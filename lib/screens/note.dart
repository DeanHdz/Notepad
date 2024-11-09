import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notepad/services/note_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notepad/models/note_model.dart' as NoteModel;

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  dynamic item; // Almacenar el argumento recibido (nota)

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recuperar el argumento de la ruta
    item = ModalRoute.of(context)?.settings.arguments;
    // Si el argumento no es nulo, cargar los datos de la nota
    if (item != null) {
      titleController.text = item.title;
      descriptionController.text = item.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B3B3B),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Nota',
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              saveNote();
            },
          ),
          item != null
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteNote();
                  },
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
              child: TextField(
                controller: descriptionController,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  hintText: 'Escribe algo...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                maxLines: null, // Permite múltiples líneas
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Eliminar la nota
  void deleteNote() {
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
      title: 'Borrar nota',
      titleTextStyle: const TextStyle(color: Colors.white),
      desc: '¿Deseas eliminar la nota?',
      descTextStyle: const TextStyle(color: Colors.white),
      btnCancelText: 'No',
      btnCancelColor: const Color(0xFF3B3B3B),
      btnOkText: 'Si',
      btnOkColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        // Lógica para eliminar la nota
        NoteService().deleteNote(item.id);
        Fluttertoast.showToast(
          msg: 'Nota eliminada',
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

  // Guardar la nota
  void saveNote() async {
    // Obtener el título y contenido de la nota
    final String title = titleController.text;
    final String description = descriptionController.text;
    //Obtener el id del usuario
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    //Validar que el título y el contenido no estén vacíos
    if (title.isEmpty || description.isEmpty) {
      // Mostrar toast de error
      Fluttertoast.showToast(
        msg: 'El título y el contenido no pueden estar vacíos',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFF3B3B3B),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Guardar la nota
    if (item == null) {
      await NoteService().createNote(userId, title, description)
          ? toastExito()
          : toastError();
    } else {
      NoteModel.Note note = item as NoteModel.Note;
      note.title = title;
      note.description = description;
      await NoteService().updateNote(note) ? toastExito() : toastError();
    }

    // Cerrar la pantalla de la nota
    Navigator.pop(context);
  }

  void toastExito() {
    Fluttertoast.showToast(
      msg: 'Nota guardada',
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
      msg: 'Error al guardar la nota',
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
    descriptionController.dispose();
    super.dispose();
  }
}

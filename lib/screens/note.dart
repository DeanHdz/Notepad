import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B3B3B),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Nota',
            style: TextStyle(color: Colors.white, fontSize: 32)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteNote();
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF252525),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Titulo',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            const Text(
              'Escribe algo...',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
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
      btnOkOnPress: () {},
    ).show();
  }
}

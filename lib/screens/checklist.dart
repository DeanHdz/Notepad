import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Checklist extends StatefulWidget {
  const Checklist({super.key});

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B3B3B),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Listado de tareas',
            style: TextStyle(color: Colors.white, fontSize: 32)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteChecklist();
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
          ],
        ),
      ),
    );
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
      btnOkOnPress: () {},
    ).show();
  }
}

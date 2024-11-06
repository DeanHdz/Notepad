import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/checklist_service.dart';
import '../models/checklist_model.dart';
import '../services/note_service.dart';
import '../models/note_model.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:notepad/components/main_list_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Elementos de la lista
  Map<String, List<dynamic>> listElements = {
    'Notes': <Note>[],
    'Checklists': <Checklist>[]
  };

  List<Note> notes = List.empty(); // Contiene todas las Notas
  List<Checklist> checklists = List.empty(); // Contiene listas de tareas

  @override
  void initState() {
    super.initState();
    _loadUserContent();
  }

  Future<void> _loadUserContent() async {
    // Obtener las preferencias del usuario, este contiene los datos de la sesión
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Consultar las notas y tareas del usuario
    List<Note> obtainedNotes =
        await NoteService().getNotes(prefs.getInt('userId') ?? 0);
    List<Checklist> obtainedChecklists =
        await ChecklistService().getChecklists(prefs.getInt('userId') ?? 0);

    // Cargar las notas y tareas del usuario
    setState(() {
      notes = obtainedNotes;
      checklists = obtainedChecklists;
      listElements['Notes'] = notes;
      listElements['Checklists'] = checklists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B3B3B),
        title: const Text('Notas y tareas',
            style: TextStyle(color: Colors.white, fontSize: 32)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem(context);
        },
        backgroundColor: const Color(0xFFFFC000),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color(0xFF252525),
      body: Column(
        children: [
          Expanded(
            child: notes.isEmpty || checklists.isEmpty
                ? const Center(
                    child: Text(
                      'No tienes notas o listas, agrega una nueva presionando el botón de abajo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w200),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GroupListView(
                            sectionsCount: listElements.keys.toList().length,
                            countOfItemInSection: (int section) {
                              return listElements.values
                                  .toList()[section]
                                  .length;
                            },
                            itemBuilder: _itemBuilder,
                            groupHeaderBuilder:
                                (BuildContext context, int section) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text(
                                  listElements.keys.toList()[section],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            sectionSeparatorBuilder: (context, section) =>
                                const SizedBox(height: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    final item = listElements.values.toList()[index.section][index.index];
    final itemType = listElements.keys.toList()[index.section];

    return MainListItem(
      item: item,
      onTap: () {
        if (itemType == 'Checklists') {
          Navigator.pushNamed(context, '/checklist', arguments: item);
        } else if (itemType == 'Notes') {
          Navigator.pushNamed(context, '/note', arguments: item);
        }
      },
    );
  }

  void addItem(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200, // Altura del modal
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Agregar',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.note_add),
                title: const Text('Nota'),
                onTap: () {
                  //Ocultar el modal, evita que se quede en la pantalla al regresar
                  Navigator.pop(context);
                  // Redirección para agregar un bloc de notas
                  Navigator.pushNamed(context, '/note');
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Listado de tareas'),
                onTap: () {
                  //Ocultar el modal, evita que se quede en la pantalla al regresar
                  Navigator.pop(context);
                  // Redirección para agregar listado de tareas
                  Navigator.pushNamed(context, '/checklist');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

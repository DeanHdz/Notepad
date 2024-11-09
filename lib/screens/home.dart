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
  Map<String, List<dynamic>> listElements = {
    'Notas': <Note>[],
    'Tareas': <Checklist>[]
  };

  List<Note> notes = [];
  List<Checklist> checklists = [];
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _loadUserContent();
  }

  Future<void> _loadUserContent() async {
    setState(() {
      isLoading = true; // Muestra el indicador de carga
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Note> obtainedNotes =
        await NoteService().getNotes(prefs.getInt('userId') ?? 0);
    List<Checklist> obtainedChecklists =
        await ChecklistService().getChecklists(prefs.getInt('userId') ?? 0);

    setState(() {
      notes = obtainedNotes;
      checklists = obtainedChecklists;
      listElements['Notas'] = notes;
      listElements['Tareas'] = checklists;
      isLoading = false; // Oculta el indicador de carga
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
        onPressed: () async {
          await addItem(context);
          await _loadUserContent(); // Recarga los datos después de añadir un nuevo elemento
        },
        backgroundColor: const Color(0xFFFFC000),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color(0xFF252525),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Colors.white), // Indicador de carga
            )
          : Column(
              children: [
                Expanded(
                  child: notes.isEmpty && checklists.isEmpty
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
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 0),
                          child: GroupListView(
                            sectionsCount: listElements.keys.length,
                            countOfItemInSection: (int section) {
                              return listElements.values
                                  .elementAt(section)
                                  .length;
                            },
                            itemBuilder: _itemBuilder,
                            groupHeaderBuilder:
                                (BuildContext context, int section) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text(
                                  listElements.keys.elementAt(section),
                                  style: const TextStyle(
                                      color: Colors.white,
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
      onTap: () async {
        if (itemType == 'Tareas') {
          await Navigator.pushNamed(context, '/checklist', arguments: item);
        } else if (itemType == 'Notas') {
          await Navigator.pushNamed(context, '/note', arguments: item);
        }
        _loadUserContent(); // Recarga los datos después de regresar a la vista de inicio
      },
    );
  }

  Future<void> addItem(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200,
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
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.pushNamed(context, '/note');
                  _loadUserContent(); // Recarga los datos después de agregar una nota
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Listado de tareas'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.pushNamed(context, '/checklist');
                  _loadUserContent(); // Recarga los datos después de agregar una tarea
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

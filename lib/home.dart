import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String listado = ''; // Contiene todas las Notas y listas de tareas

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
            child: listado.isEmpty
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
                        children: listado
                            .split('\n')
                            .map((item) => Card(
                                  color: const Color(0xFF3B3B3B),
                                  child: ListTile(
                                    title: Text(item,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 24)),
                                    subtitle: const Text('Contenido de la nota',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          listado =
                                              listado.replaceAll('$item\n', '');
                                        });
                                      },
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
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
                leading: const Icon(Icons.note),
                title: const Text('Nota'),
                onTap: () {
                  // Acción para agregar texto
                  Navigator.pop(context); // Cierra el modal
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Listado de tareas'),
                onTap: () {
                  // Acción para agregar listado
                  Navigator.pop(context); // Cierra el modal
                },
              ),
            ],
          ),
        );
      },
    );
  }
}



/*

Column(
              children: <Widget>[
                Card(
                  color: const Color(0xFF3B3B3B),
                  child: ListTile(
                    title: Text('Nota 1',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                    subtitle: Text('Contenido de la nota',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ),
              ]),

*/
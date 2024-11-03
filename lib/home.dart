import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String listado = ''; //Continene todas las Notas y listas de tareas

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
          addItem();
        },
        backgroundColor: const Color(0xFFFFC000),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color(0xFF252525),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: listado.isEmpty
                ? [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No tienes notas o listas, agrega una nueva presionando el botón de abajo',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    ),
                  ]
                : listado
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
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  listado = listado.replaceAll('$item\n', '');
                                });
                              },
                            ),
                          ),
                        ))
                    .toList(),
          ),
        ),
      ),
    );
  }

  void addItem() {}
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
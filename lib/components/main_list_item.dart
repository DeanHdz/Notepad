import 'package:flutter/material.dart';

class MainListItem extends StatefulWidget {
  const MainListItem({super.key});

  @override
  State<MainListItem> createState() => _MainListItemState();
}

class _MainListItemState extends State<MainListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
    ]);
  }
}

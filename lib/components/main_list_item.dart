import 'package:flutter/material.dart';

class MainListItem extends StatelessWidget {
  final dynamic item;

  const MainListItem(
      {super.key, required this.item, required Null Function() onTap});

  @override
  Widget build(BuildContext context) {
    String itemType = item.runtimeType.toString(); // Tipo de elemento
    String title = item.title; // Título del elemento
    String description;

    switch (itemType) {
      case 'Note':
        description = item.description;
        break;
      default:
        description = '';
        break;
    }

    return Card(
      color: const Color(0xFF3B3B3B),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        subtitle: description != ''
            ? Text(
                truncateDescription(description),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            : null, // Si no hay descripción, se omite el subtítulo
        trailing: Icon(
          getIcon(itemType),
          color: Colors.white,
        ),
      ),
    );
  }

  // Método para truncar la descripción
  String truncateDescription(String description, {int maxLength = 50}) {
    if (description.length <= maxLength) {
      return description;
    }
    return '${description.substring(0, maxLength)}...';
  }

  // Método que devuelve el ícono según el tipo de elemento
  IconData getIcon(String itemType) {
    switch (itemType) {
      case 'Note':
        return Icons.note;
      case 'Checklist':
        return Icons.checklist;
      default:
        return Icons.error;
    }
  }
}

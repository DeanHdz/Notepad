import 'package:flutter/material.dart';

class MainListItem extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;

  const MainListItem({super.key, required this.item, required this.onTap});

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

    return Container(
      color: const Color(0xFF131313),
      child: ListTile(
        leading: Container(
          width: 6,
          color: const Color(0xFFFFB700),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        /*subtitle: description != ''
            ? Text(
                truncateDescription(description),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            : null,*/ // Si no hay descripción, se omite el subtítulo
        trailing: Icon(
          getIcon(itemType),
          color: Colors.white,
        ),
        onTap: onTap,
      ),
    );
  }

  // Método para truncar la descripción
  String truncateDescription(String description, {int maxLength = 20}) {
    if (description.length <= maxLength) {
      return description;
    }
    return '${description.substring(0, maxLength)}...';
  }

  // Método que devuelve el ícono según el tipo de elemento
  IconData getIcon(String itemType) {
    switch (itemType) {
      case 'Note':
        return Icons.sticky_note_2;
      case 'Checklist':
        return Icons.checklist;
      default:
        return Icons.error;
    }
  }
}

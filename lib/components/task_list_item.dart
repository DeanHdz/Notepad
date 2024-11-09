import 'package:flutter/material.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class TaskListItem extends StatefulWidget {
  final int id;
  final String content;
  final bool isDone;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.id,
    required this.content,
    required this.isDone,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RoundCheckBox(
        size: 30,
        checkedColor: Colors.green,
        uncheckedColor: Colors.white,
        isChecked: widget.isDone,
        onTap: (selected) {
          widget.onChanged(selected ?? false);
        },
      ),
      title: Text(
        widget.content,
        style: TextStyle(
          color: Colors.white,
          decoration: widget.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: widget.onDelete,
      ),
    );
  }
}

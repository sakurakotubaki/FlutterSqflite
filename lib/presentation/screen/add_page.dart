import 'package:flutter/material.dart';
import 'package:sqflite_app/controller/note_controller.dart';
import 'package:sqflite_app/domain/entity/note_model.dart';
import 'package:sqflite_app/domain/repository/note_repository.dart';

class AddPage extends StatefulWidget {
  final Note? note;
  const AddPage({Key? key, this.note}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // DIしたクラス　
  late NoteRepositoryImpl noteRepositoryImpl;
  late NoteController noteController;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    noteRepositoryImpl = NoteRepositoryImpl();
    noteController = NoteController(noteRepositoryImpl);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Note')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final title = titleController.value.text;
                    final description = descriptionController.value.text;
                    if (title.isEmpty || description.isEmpty) {
                      return;
                    }

                    final Note model = Note(
                        title: title,
                        description: description,
                        id: widget.note?.id);
                    await noteController.insert(model);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('保存'),
                ),
              ],
            )));
  }
}

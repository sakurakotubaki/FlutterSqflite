import 'package:flutter/material.dart';
import 'package:sqflite_app/model/note_model.dart';
import 'package:sqflite_app/service/database_helper.dart';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  final Note? note;
  const EditPage({Key? key, required this.note}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    dispose() {
      titleController.dispose();
      descriptionController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EditPage'),
      ),
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

                  DatabaseHelper().updateNote(model);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('更新'),
              ),
            ],
          )),
    );
  }
}

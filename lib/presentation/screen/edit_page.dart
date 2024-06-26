import 'package:flutter/material.dart';
import 'package:sqflite_app/controller/note_controller.dart';
import 'package:sqflite_app/domain/entity/note_model.dart';
import 'package:sqflite_app/domain/repository/note_repository.dart';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  final Note? note;
  const EditPage({Key? key, required this.note}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  // DIしたクラス　
  late NoteRepositoryImpl noteRepositoryImpl;
  late NoteController noteController;

  @override
  void initState() {
    super.initState();
    noteRepositoryImpl = NoteRepositoryImpl();
    noteController = NoteController(noteRepositoryImpl);
  }
  
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    @override
    void dispose() {
      titleController.dispose();
      descriptionController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green,
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

                  await noteController.update(model);
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

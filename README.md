# sqflite_app

**古いが、日本語で解説されている記事**
https://flutter.ctrnost.com/logic/sqlite/

## データの表示
データを表示する時には、FutureBuilderを使用する。ゴミ箱のボタンを押すと削除できる。
```dart
import 'package:flutter/material.dart';
import 'package:sqflite_app/model/note_model.dart';
import 'package:sqflite_app/screen/edit_page.dart';
import 'package:sqflite_app/service/database_helper.dart';

class NotePage extends StatefulWidget {
  NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Edit Page'),
        ),
        body: FutureBuilder<List<Note>?>(
          future: DatabaseHelper.getAllNote(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final note = snapshot.data![index];
                    return ListTile(
                      // 編集ページから戻ってきたときに、リストを更新するためにsetStateを呼び出す
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPage(note: note)));
                        setState(() {});
                      },
                      leading: IconButton(
                          onPressed: () {
                            DatabaseHelper.deleteNote(note);
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete)),
                      title: Text(note.title),
                      subtitle: Text(note.description),
                    );
                  },
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
```

## データの追加
データを追加するときは、メソッドを呼び出すだけ
```dart
import 'package:flutter/material.dart';
import 'package:sqflite_app/model/note_model.dart';
import 'package:sqflite_app/service/database_helper.dart';

class AddPage extends StatelessWidget {
  final Note? note;
  const AddPage({Key? key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

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
                        title: title, description: description, id: note?.id);
                    await DatabaseHelper.addNote(model);
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
```

## データの更新
データを編集するときは、前のページから、`id`を渡して、メソッドに渡すとデータを指定して編集ができるようになる。
```dart
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

                  DatabaseHelper.updateNote(model);
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
```
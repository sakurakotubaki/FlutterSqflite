import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_app/model/note_model.dart';
import 'package:sqflite_app/service/database_helper.dart';

final allDataProvider = FutureProvider.autoDispose<List<Note>?>((ref) async {
  ref.keepAlive(); // keepAliveは、状態を一定期間保持するためのメソッド
  final databaseHelper = ref.watch(databaseHelperProvider);
  return databaseHelper.getAllNote();
});

final databaseHelperProvider = Provider((ref) {
  return DatabaseHelper();
});

final titleProvider = StateProvider((ref) {
  return TextEditingController();
});

final descriptionProvider = StateProvider((ref) {
  return TextEditingController();
});

class FutureAdd extends ConsumerWidget {
  const FutureAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(titleProvider);
    final description = ref.watch(descriptionProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Future Add'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: description,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (title.text.isEmpty || description.text.isEmpty) {
                    return;
                  }

                  final Note model =
                      Note(title: title.text, description: description.text);
                  await ref.read(databaseHelperProvider).addNote(model);
                  // ignore: unused_result
                  ref.refresh(allDataProvider);
                  title.clear();
                  description.clear();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('保存'),
              ),
            ],
          )),
    );
  }
}

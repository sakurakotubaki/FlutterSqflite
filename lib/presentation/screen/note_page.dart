import 'package:flutter/material.dart';
import 'package:sqflite_app/controller/note_controller.dart';
import 'package:sqflite_app/domain/entity/note_model.dart';
import 'package:sqflite_app/domain/repository/note_repository.dart';
import 'package:sqflite_app/presentation/screen/edit_page.dart';
import 'package:sqflite_app/presentation/widget/indicator_widget.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // DIしたクラス　
  late NoteRepositoryImpl noteRepositoryImpl;
  late NoteController noteController;

  @override
  void initState() {
    super.initState();
    noteRepositoryImpl = NoteRepositoryImpl();
    noteController = NoteController(noteRepositoryImpl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Edit Page'),
        ),
        body: FutureBuilder<List<Note>?>(
          future: noteController.getNotes(),
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
                            noteController.delete(note);
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
              child:  IndicatorWidget(),
            );
          },
        ));
  }
}

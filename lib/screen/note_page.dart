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

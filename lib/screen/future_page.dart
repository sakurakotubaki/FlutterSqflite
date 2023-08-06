import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_app/model/note_model.dart';
import 'package:sqflite_app/service/database_helper.dart';

final databaseHelperProvider = Provider((ref) {
  return DatabaseHelper();
});

final allDataProvider = FutureProvider.autoDispose<List<Note>?>((ref) async {
  ref.keepAlive(); // keepAliveは、状態を一定期間保持するためのメソッド
  final databaseHelper = ref.watch(databaseHelperProvider);
  return databaseHelper.getAllNote();
});

class FuturePage extends ConsumerStatefulWidget {
  const FuturePage({Key? key}) : super(key: key);

  @override
  _FuturePageState createState() => _FuturePageState();
}

class _FuturePageState extends ConsumerState<FuturePage> {
  @override
  void initState() {
    super.initState();
    // ignore: unused_result
    ref.refresh(allDataProvider);
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(allDataProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('FuturePageState'),
      ),
      body: notes.when(
          data: (note) {
            if (note == null) {
              return const Center(
                child: Text('データがありません'),
              );
            }
            return ListView.builder(
              itemCount: note.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                      onPressed: () {
                        ref
                            .read(databaseHelperProvider)
                            .deleteNote(note[index]);
                        // ignore: unused_result
                        ref.refresh(allDataProvider);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red)),
                  title: Text(note[index].title),
                  subtitle: Text(note[index].description),
                );
              },
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
    );
  }
}

// class FuturePage extends ConsumerWidget {
//   const FuturePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // 他のページでデータを追加して戻ってきたときに、データを更新するためのコード
//     // このページが呼ばれるたびに、データを更新する
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // ignore: unused_result
//       ref.refresh(allDataProvider);
//     });

//     final notes = ref.watch(allDataProvider);
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.amber,
//           title: const Text('Future Page'),
//         ),
//         body: notes.when(
//           data: (note) {
//             if (note == null) {
//               return const Center(
//                 child: Text('データがありません'),
//               );
//             }
//             return ListView.builder(
//               itemCount: note.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: IconButton(
//                       onPressed: () {
//                         ref
//                             .read(databaseHelperProvider)
//                             .deleteNote(note[index]);
//                         // ignore: unused_result
//                         ref.refresh(allDataProvider);
//                       },
//                       icon: const Icon(Icons.delete, color: Colors.red)),
//                   title: Text(note[index].title),
//                   subtitle: Text(note[index].description),
//                 );
//               },
//             );
//           },
//           error: (error, stackTrace) => Center(
//             child: Text(error.toString()),
//           ),
//           loading: () => const Center(
//             child: CircularProgressIndicator(),
//           ),
//         ));
//   }
// }

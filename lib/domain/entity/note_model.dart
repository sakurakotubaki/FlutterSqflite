// メモ帳のモデルクラス
class Note {
  final int? id;// null許容型
  final String title;
  final String description;

  Note({
    this.id,
    required this.title,
    required this.description,
  });
  // データベースから取得したデータをモデルクラスに変換する
  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
      );
  // モデルクラスをデータベースに保存するためにMap型に変換する
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
      };
}

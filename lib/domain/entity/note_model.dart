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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode;
  
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

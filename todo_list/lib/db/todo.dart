class Todo {
  final String date; // date를 id로 사용
  final String category;
  final String text;
  final String memo;
  final int checked; // 0: false, 1: true

  Todo(
      {required this.date,
      required this.category,
      required this.text,
      required this.memo,
      required this.checked});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'category': category,
      'text': text,
      'memo': memo,
      'checked': checked
    };
  }
}

class Todo {
  int id;
  String title;
  int checked;

  Todo({required this.id, this.title = "", this.checked = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'checked': checked,
    };
  }
}

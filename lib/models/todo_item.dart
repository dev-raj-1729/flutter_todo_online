class TodoItem {
  int? id;
  String title;
  TodoItem(this.title, {this.id});
  Map<String, String> toMap() {
    return {"title": title};
  }

  TodoItem.fromMap(Map<String, dynamic> map)
      : this.title = map['title']!,
        this.id = map['id'];
}

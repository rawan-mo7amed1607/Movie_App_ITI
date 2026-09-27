class Task {
  int? id;
  String title;
  String desc;
  bool isDone;

  Task({
    this.id,
    required this.title,
    required this.desc,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      isDone: map['isDone'] == 1,
    );
  }
}
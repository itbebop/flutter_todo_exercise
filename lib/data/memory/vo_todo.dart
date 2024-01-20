import 'todo_status.dart';

class Todo {
  // memory 폴더는 ram에 임시로 갖고있다가 지워지는 데이터들 저장

  Todo({
    required this.id,
    required this.title,
    required this.dueDate,
    this.status = TodoStatus.incomplete,
  }) : createdTime = DateTime.now();

  int id;
  String title;
  final DateTime createdTime;
  DateTime? modifyTime;
  DateTime dueDate;
  TodoStatus status;
}

import 'package:fast_app_base/data/memory/todo_data_notifier.dart';
import 'package:fast_app_base/data/memory/todo_status.dart';
import 'package:flutter/material.dart';

import '../../screen/dialog/d_confirm.dart';
import '../../screen/main/write/d_write.dart';
import 'vo_todo.dart';

class TodoDataHolder extends InheritedWidget {
  final TodoDataNotifier notifier;

  const TodoDataHolder({
    super.key,
    required super.child,
    required this.notifier,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static TodoDataHolder _of(BuildContext context) {
    // 같은 위젯 트리의 위젯 어디든 TodoDataHolder를 찾아서 돌려주는 역할
    TodoDataHolder inherited =
        (context.dependOnInheritedWidgetOfExactType<TodoDataHolder>())!;
    return inherited;
  }

  // 이 클래스가 data holder뿐 아니라 아래의 business역할까지 하게됨
  // 원래대로면 클래스를 나눠야하지만 코드가 길지 않아서 그대로 둠
  void changeTodoStatus(Todo todo) async {
    switch (todo.status) {
      case TodoStatus.incomplete:
        todo.status = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        todo.status = TodoStatus.complete;
      case TodoStatus.complete:
        final result = await ConfirmDialog('정말로 처음 상태로 변경하시곘어요?').show();
        result?.runIfSuccess((data) {
          todo.status = TodoStatus.incomplete;
        });
    }
    //notifier.notifyListeners();
    notifier.notify();
  }

  void addTodo() async {
    // WriteTodoResult? 타입으로 받음 (WriteTodoDialog의 13줄에 명시해서)
    final result = await WriteTodoDialog().show();
    // 여기선 mount check불가. 흐름상 mount된 건 보장됨
    if (result != null) {
      //if (result != null && mounted) {
      // await 이후에 context가 유효하지 않게 될 수 있어 아래 부분 문제될 수도 있다. 그래서 mounted여부도 체크
      // mounted는 현재 스크린이 살아있는지 체크
      //context.holder.notifier.addTodo(Todo(
      // holder내부라서 바로 접근 가능
      notifier.addTodo(Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: result.text,
        dueDate: result.dateTime,
      ));
      //debugPrint(result.text);
      //debugPrint(result.dateTime.formattedDate);
    }
  }

  // dialog
  void editTodo(Todo todo) async {
    final result = await WriteTodoDialog(todoForEdit: todo).show();
    if (result != null) {
      debugPrint(result.toString());
      todo.title = result.text;
      todo.dueDate = result.dateTime;
      // 화면 갱신
      notifier.notify();
    }
  }

  void removeTodo(Todo todo) {
    // value가 todo 리스트 데이터
    notifier.value.remove(todo);
    notifier.notify();
  }
}

// TodoDataHoler.of(this) 사용하지 않도록 강제
extension TodoDataHolerContextExtension on BuildContext {
  TodoDataHolder get holder => TodoDataHolder._of(this);
}

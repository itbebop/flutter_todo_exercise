import 'package:fast_app_base/data/memory/todo_data_notifier.dart';
import 'package:flutter/material.dart';

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
    TodoDataHolder inherited = (context.dependOnInheritedWidgetOfExactType<TodoDataHolder>())!;
    return inherited;
  }
}

// TodoDataHoler.of(this) 사용하지 않도록 강제
extension TodoDataHolerContextExtension on BuildContext {
  TodoDataHolder get holder => TodoDataHolder._of(this);
}

import 'package:flutter/material.dart';

import 'vo_todo.dart';

class TodoDataNotifier extends ValueNotifier<List<Todo>> {
  // 생성시점에 value를 받는 것이 아니라
  // TodoDataNotifier(super.value);
  // 생성시점엔 아무것도 받지 않고 빈 list로 초기화해줌
  TodoDataNotifier() : super([]);

  void addTodo(Todo todo) {
    // 타입으로 선언한 list todo가 value의 타입
    value.add(todo); // value에 받아온 todo를 넣고
    notifyListeners(); // TodoDataNotifier를 사용하고 있는 곳에 데이터변경 알림
  }
}

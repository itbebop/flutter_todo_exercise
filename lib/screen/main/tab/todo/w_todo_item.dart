import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/dart/extension/datetime_extension.dart';
import 'package:fast_app_base/common/widget/w_rounded_container.dart';
import 'package:flutter/material.dart';

import '../../../../data/memory/vo_todo.dart';
import 'w_todo_status.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    // Dismissible(스와이프 삭제)
    return Dismissible(
      // 실제로 삭제
      // direction에 따라 다른 효과 넣으려면 분기처리하면 됨
      onDismissed: (direction) {
        context.holder.removeTodo(todo);
      },
      // 삭제할 때 휴지통
      background: RoundedContainer(
        color: context.appColors.removeTodoBg,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Width(20),
            Icon(
              EvaIcons.trash2Outline,
              color: Colors.white,
            )
          ],
        ),
      ),
      // 오른쪽에 아이콘
      secondaryBackground: RoundedContainer(
        color: context.appColors.removeTodoBg,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              EvaIcons.trash2Outline,
              color: Colors.white,
            ),
            Width(20),
          ],
        ),
      ),
      // Key값으로는 유니크한 값을 넣어주면 됨
      key: ValueKey(todo.id),
      child: RoundedContainer(
          margin: const EdgeInsets.only(bottom: 6),
          color: context.appColors.itemBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              todo.dueDate.relativeDays.text.make(),
              Row(
                children: [
                  TodoStatusWidget(todo),
                  Expanded(child: todo.title.text.size(20).medium.make()),
                  IconButton(
                    onPressed: () async {
                      //print(todo.dueDate);
                      //print(todo.title);
                      context.holder.editTodo(todo);
                    },
                    icon: const Icon(EvaIcons.editOutline),
                  )
                ],
              )
            ],
          ).pOnly(top: 15, right: 15, left: 5, bottom: 10)),
    );
  }
}

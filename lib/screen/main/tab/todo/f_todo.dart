import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/dart/extension/color_extension.dart';
import 'package:flutter/material.dart';

import 'w_todo_list.dart';

class TodoFragment extends StatefulWidget {
  const TodoFragment({super.key});

  @override
  State<TodoFragment> createState() => _TodoFragmentState();
}

class _TodoFragmentState extends State<TodoFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appColors.seedColor.getSwatchByBrightness(100), // 0~1000까지의 값으로 밝기 조정
      child: Column(children: [
        Row(
          children: [
            IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(
                  Icons.menu,
                ))
          ],
        ),
        Expanded(child: const TodoListWidget().pSymmetric(h: 15)), // 실제 데이터는 holder notifier에서 들고 있으므로 -> TodoList는 stateless위젯
      ]),
    );
  }
}

import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/widget/scaffold/bottom_dialog_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:nav/dialog/dialog.dart';

import '../../../common/widget/w_rounded_container.dart';

class WriteTodoDialog extends DialogWidget {
  WriteTodoDialog({super.key});

  @override
  DialogState<WriteTodoDialog> createState() => _WriteTodoDialogState();
}

class _WriteTodoDialogState extends DialogState<WriteTodoDialog> {
  @override
  Widget build(BuildContext context) {
    return BottomDialogScaffold(
        body: RoundedContainer(
      color: context.backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              '할일을 작성해주세요'.text.size(18).bold.make(),
              spacer,
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.calendar_month))
            ],
          ),
          Height(20),
        ],
      ),
    ));
  }
}

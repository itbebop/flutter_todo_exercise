import 'package:after_layout/after_layout.dart';
import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/dart/extension/datetime_extension.dart';
import 'package:fast_app_base/common/util/app_keyboard_util.dart';
import 'package:fast_app_base/common/widget/scaffold/bottom_dialog_scaffold.dart';
import 'package:fast_app_base/common/widget/w_round_button.dart';
import 'package:fast_app_base/screen/main/write/vo_write_todo_result.dart';
import 'package:flutter/material.dart';
import 'package:nav/dialog/dialog.dart';

import '../../../common/widget/w_rounded_container.dart';

class WriteTodoDialog extends DialogWidget<WriteTodoResult> {
  WriteTodoDialog({super.key});

  @override
  DialogState<WriteTodoDialog> createState() => _WriteTodoDialogState();
}

// AfterLayoutMixin -> 화면 그려진 후 keyboard 나오게
class _WriteTodoDialogState extends DialogState<WriteTodoDialog> with AfterLayoutMixin {
  // 달력클릭했을 때 받을 날짜, 변할 수 있어서 final로 받지 않음
  DateTime _selectedDate = DateTime.now();
  final textController = TextEditingController();
  // keyboard 보일지 여부
  final node = FocusNode();

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
              _selectedDate.relativeDays.text.make(),
              IconButton(onPressed: _selectDate, icon: const Icon(Icons.calendar_month)),
            ],
          ),
          heigh20,
          Row(
            children: [
              // roundbutton 빼고는 꽉 찬 형태로 하기 위해 expaned로 감쌈
              Expanded(
                  child: TextField(
                focusNode: node,
                controller: textController,
              )),
              RoundButton(
                  text: '추가',
                  onTap: () {
                    widget.hide(WriteTodoResult(_selectedDate, textController.text));
                  }),
            ],
          )
        ],
      ),
    ));
  }

  void _selectDate() async {
    final date =
        await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime.now().add(const Duration(days: 365 * 10)));
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppKeyboardUtil.show(context, node);
  }
}

import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate => DateFormat('yyyy년 MM월 dd일').format(this);

  String get formattedTime => DateFormat('HH:mm').format(this);

  String get formattedDateTime => DateFormat('dd/MM/yyyy HH:mm').format(this);

  String get relativeDays {
    final diffDays = difference(DateTime.now().onlyDate).inDays;
    final isNegative = diffDays.isNegative;

    final checkCondition = (diffDays, isNegative);
    return switch (checkCondition) {
      // 두 번째 값이 얼마든 첫번째값이 0/1/_(음수)이면 우측의 값을 돌려줌
      (0, _) => _tillToday,
      (1, _) => _titleTomorrow,
      (_, true) => _dayPassed,
      _ => _dayLeft,
    };
  }

  DateTime get onlyDate {
    return DateTime(year, month, day);
  }

  String get _dayLeft => 'daysLeft'.tr(namedArgs: {"daysCount": difference(DateTime.now().onlyDate).inDays.toString()});

  String get _dayPassed => 'daysPassed'.tr(namedArgs: {"daysCount": difference(DateTime.now().onlyDate).inDays.abs().toString()});

  String get _tillToday => 'tillToday'.tr();

  String get _titleTomorrow => 'tillTomorrow'.tr();
}

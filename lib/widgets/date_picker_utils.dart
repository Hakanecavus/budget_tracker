import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required Function(DateTime) onDateTimeChanged,
  DateTime? minimumDate,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => Container(
      height: 250,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: CupertinoDatePicker(
              initialDateTime: initialDate,
              mode: mode,
              use24hFormat: true,
              minimumDate: minimumDate,
              onDateTimeChanged: onDateTimeChanged,
            ),
          ),
        ],
      ),
    ),
  );
}

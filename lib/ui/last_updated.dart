import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  final DateTime date;

  DateFormatter({this.date});

  String lastUpdatedStatus() {
    if (date != null) {
      final formatter = DateFormat.yMd().add_Hms();
      final formatted = formatter.format(date);
      return 'Last Updated: $formatted';
    } else {
      return '';
    }
  }
}

class LastUpdated extends StatelessWidget {
  final String text;

  const LastUpdated({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w400),
    );
  }
}

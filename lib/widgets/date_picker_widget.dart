import 'package:flutter/material.dart';
import 'package:instary/widgets/button_widget.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({Key? key}) : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? date;

  String getText() {
    if (date == null) {
      return 'Select Date';
    }
    return DateFormat('yyyy-MM-dd HH:mm').format(date!);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonHeaderWidget(
        title: 'Date', text: getText(), onClicked: () => pickDate(context));
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate:
          date ?? initialDate, // if date is null, use initialDate else use date
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
  }
}

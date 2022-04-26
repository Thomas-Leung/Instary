import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepCard extends StatefulWidget {
  final DateTime existingDateTime;
  final DateTime? existingBedTime;
  final DateTime? existingWakeUpTime;
  final Function(DateTime?, DateTime?) onSleepTimeChanged;

  const SleepCard(
      {Key? key,
      required this.existingDateTime,
      this.existingBedTime,
      this.existingWakeUpTime,
      required this.onSleepTimeChanged})
      : super(key: key);

  @override
  State<SleepCard> createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard> {
  late DateTime dateTime;
  DateTime? bedTime;
  DateTime? wakeUpTime;

  @override
  void initState() {
    super.initState();
    dateTime = widget.existingDateTime;
    bedTime = widget.existingBedTime;
    wakeUpTime = widget.existingWakeUpTime;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sleep Tracker',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      bedTime = null;
                      wakeUpTime = null;
                    });
                    widget.onSleepTimeChanged(bedTime, wakeUpTime);
                  },
                  child: const Text('reset'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(40, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? tempTime = await pickDateTime(context, bedTime);
                      if (tempTime == null) return;
                      if (wakeUpTime == null ||
                          tempTime.isBefore(wakeUpTime!) ||
                          tempTime == bedTime) {
                        setState(() => bedTime = tempTime);
                        widget.onSleepTimeChanged(bedTime, wakeUpTime);
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Oops!"),
                            content: Text(
                                "Sleep time cannot be after wake up time."),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                          ),
                          barrierDismissible: false,
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100, //0xffea9c90
                      decoration: BoxDecoration(
                        color: Color(0xff4b3062),
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            bottomLeft: const Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Sleep",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        bedTime == null
                                            ? "Tap to Pick Date"
                                            : DateFormat('HH:mm')
                                                .format(bedTime!),
                                        style: TextStyle(
                                            fontSize: bedTime == null ? 14 : 28,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        bedTime == null
                                            ? ""
                                            : DateFormat('yyyy/MM/dd')
                                                .format(bedTime!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: -22,
                              left: 2,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff4b3062),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(Icons.nightlight,
                                        color: Colors.amber[200], size: 20),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? tempTime =
                          await pickDateTime(context, wakeUpTime);
                      if (tempTime == null) return;
                      if (bedTime == null ||
                          tempTime.isAfter(bedTime!) ||
                          tempTime == bedTime) {
                        setState(() => wakeUpTime = tempTime);
                        widget.onSleepTimeChanged(bedTime, wakeUpTime);
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Oops!"),
                            content:
                                Text("Wake up time cannot be before bed time."),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                          ),
                          barrierDismissible: false,
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xffea9c90),
                        borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(10.0),
                            bottomRight: const Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Wake up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        wakeUpTime == null
                                            ? "Tap to Pick Date"
                                            : DateFormat('HH:mm')
                                                .format(wakeUpTime!),
                                        style: TextStyle(
                                            fontSize:
                                                wakeUpTime == null ? 14 : 28,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        wakeUpTime == null
                                            ? ""
                                            : DateFormat('yyyy/MM/dd')
                                                .format(wakeUpTime!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: -22,
                              left: 2,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffea9c90),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Icon(Icons.light_mode,
                                        color: Colors.amber[100], size: 20),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> pickDateTime(
      BuildContext context, DateTime? existingDate) async {
    final DateTime? date = await pickDate(context, existingDate);
    if (date == null) return null;

    final TimeOfDay? time = await pickTime(context, existingDate);
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<DateTime?> pickDate(
      BuildContext context, DateTime? existingDate) async {
    final initialDate = dateTime;

    final newDate = await showDatePicker(
      context: context,
      initialDate: existingDate ??
          initialDate, // if existingDate is null, use initialDate else use date
      firstDate: initialDate.subtract(Duration(days: 1)),
      lastDate: initialDate,
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
    return newDate;
  }

  Future<TimeOfDay?> pickTime(
      BuildContext context, DateTime? existingDate) async {
    final TimeOfDay initialTime = TimeOfDay.fromDateTime(DateTime.now());
    TimeOfDay? existingTime;

    if (existingDate != null) {
      existingTime = TimeOfDay.fromDateTime(existingDate);
    }
    final newTime = await showTimePicker(
      context: context,
      initialTime: existingTime ?? initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return newTime;
  }
}

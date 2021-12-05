import 'package:flutter/material.dart';

// Reference: https://medium.com/flutter-community/flutter-beginners-guide-to-using-the-bottom-sheet-b8025573c433
class ImportExportListTile extends StatefulWidget {
  final Function function;
  final Icon icon;
  final String displayName;
  final String processStatus;
  final String completeStatus;
  final String errorStatus;

  ImportExportListTile(
      {required this.function,
      required this.icon,
      required this.displayName,
      required this.processStatus,
      required this.completeStatus,
      required this.errorStatus});

  @override
  _ImportExportListTileState createState() => _ImportExportListTileState();
}

// Reference: https://medium.com/swlh/use-valuenotifier-like-pro-6441d9ddad05
class ProgressNotifier extends ValueNotifier<bool> {
  ProgressNotifier({required bool value}) : super(value);

  void processComplete() {
    value = true;
  }
}

class _ImportExportListTileState extends State<ImportExportListTile> {
  late ProgressNotifier _progressNotifier;
  late Color bottomSheetColor;
  late String status;
  bool processing = false;

  @override
  void initState() {
    super.initState();
    status = widget.processStatus;
    // set false as we haven't complete import/export
    _progressNotifier = ProgressNotifier(value: false);
    // use future because we need to get the context
    Future.delayed(Duration.zero, () {
      bottomSheetColor = Theme.of(context).sliderTheme.thumbColor!;
    });
  }

  @override
  void dispose() {
    _progressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: Text(widget.displayName),
        leading: widget.icon,
        onTap: () async {
          if (!processing) {
            processing = true;
            bool processResult = await widget.function();
            Scaffold.of(context).showBottomSheet<void>(
              (BuildContext context) {
                return StatefulBuilder(
                  builder:
                      (BuildContext context, StateSetter setBottomSheetState) {
                    return Container(
                      margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _progressNotifier,
                            builder: (context, value, child) => Container(
                              height:
                                  50, // column centers and the height makes it "float"
                              decoration: BoxDecoration(
                                color: bottomSheetColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 16.0),
                                        child: !value
                                            ? Container(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : processResult
                                                ? Icon(
                                                    Icons.check_rounded,
                                                    color: Colors.white,
                                                  )
                                                : Icon(
                                                    Icons.error_outline,
                                                    color: Colors.white,
                                                  ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
            await Future.delayed(Duration(seconds: 2));
            if (processResult) {
              status = widget.completeStatus;
              bottomSheetColor = Colors.green;
            } else {
              status = widget.errorStatus;
              bottomSheetColor = Colors.red[800]!;
            }
            _progressNotifier.processComplete();
            await Future.delayed(Duration(seconds: 2));
            Navigator.pop(context);
            // Reset values
            status = widget.processStatus;
            _progressNotifier = ProgressNotifier(value: false);
            bottomSheetColor = Theme.of(context).sliderTheme.thumbColor!;
            processing = false;
          }
        },
      ),
    );
  }
}

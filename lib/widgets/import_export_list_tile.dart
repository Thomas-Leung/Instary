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

class _ImportExportListTileState extends State<ImportExportListTile> {
  bool _enableListTile = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: Text(widget.displayName),
        leading: widget.icon,
        enabled: _enableListTile,
        onTap: () async {
          setState(() => _enableListTile = false);
          Scaffold.of(context).showBottomSheet<void>(
            (BuildContext context) {
              return Container(
                margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FutureBuilder(
                      future: widget.function(),
                      builder: (context, snapshot) {
                        String status = widget.processStatus;
                        Widget icon = CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white);
                        Color bottomSheetColor =
                            Theme.of(context).sliderTheme.thumbColor!;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                        } else {
                          if (snapshot.hasError || snapshot.data != true) {
                            status = widget.errorStatus;
                            icon = Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            );
                            bottomSheetColor = Colors.red[800]!;
                          } else {
                            status = widget.completeStatus;
                            icon = Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                            );
                            bottomSheetColor = Colors.green;
                          }
                          Future.delayed(const Duration(seconds: 4), () {
                            // Close bottom sheet and re-enable listTile
                            setState(() => _enableListTile = true);
                            Navigator.pop(context);
                          });
                        }
                        return Container(
                          height:
                              50, // column centers and the height makes it "float"
                          decoration: BoxDecoration(
                            color: bottomSheetColor,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Center(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                            color: Colors.white,
                                            // fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      child: icon,
                                    ),
                                  ),
                                ]),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TagsCard extends StatefulWidget {
  const TagsCard({Key? key}) : super(key: key);

  @override
  State<TagsCard> createState() => _TagsCardState();
}

class _TagsCardState extends State<TagsCard> {
  late TextEditingController textEditingController;
  List<String> database = ["apple", "orange"];
  List<String> tags = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Tags',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 5.0,
              children: List<Widget>.generate(
                tags.length,
                (int index) {
                  return InputChip(
                    backgroundColor:
                        MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? Colors.blueGrey[50]
                            : Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    label: Text('${tags.elementAt(index)}'),
                    onDeleted: () {
                      setState(() {
                        tags.removeAt(index);
                      });
                    },
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return database.where(
                        (String option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        },
                      );
                    },
                    onSelected: (String selection) {
                      debugPrint('You just selected $selection');
                      textEditingController.text = '';
                      setState(() {
                        tags.add(selection);
                      });
                    },
                    // customize textfield, Ref: https://medium.flutterdevs.com/explore-autocomplete-widget-in-flutter-70d3478bacc4
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      textEditingController = fieldTextEditingController;
                      return TextField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: "Type something",
                          labelText: "Add a tag for today",
                          alignLabelWithHint: true,
                        ),
                        onSubmitted: (value) {
                          if (value.replaceAll(' ', '') != '') {
                            setState(() {
                              tags.add(value);
                            });
                            textEditingController.text = '';
                          }
                        },
                      );
                    },
                    // customize autocomplete list
                    optionsViewBuilder: (_, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(15.0),
                          child: SizedBox(
                            height: 180,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String tag = options.elementAt(index);
                                return InkWell(
                                  onTap: () {
                                    onSelected(tag);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(tag),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  iconSize: 32,
                  padding: EdgeInsets.only(left: 8),
                  constraints: BoxConstraints(),
                  icon: const Icon(Icons.add),
                  tooltip: 'Add a tag',
                  onPressed: () {
                    if (textEditingController.text.replaceAll(' ', '') != '') {
                      setState(() {
                        tags.add(textEditingController.text);
                      });
                      textEditingController.text = '';
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

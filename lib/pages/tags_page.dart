import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  final tagBox = Hive.box('tag');

  @override
  Widget build(BuildContext context) {
    List<String> tags = tagBox.keys.toList().cast();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: tags.length > 0
          ? ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: tags.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tags[index]),
                          Icon(
                            Icons.delete,
                            size: 30.0,
                            color: Colors.red[800],
                          )
                        ],
                      ),
                    ],
                  ),
                  onTap: () => _showDeleteDialog(tags[index]),
                );
              })
          : const Center(child: Text('No items')),
    );
  }

  void _showDeleteDialog(key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Text("Delete tag"),
          content: Text("Are you sure you want to delete $key?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red[800])),
              onPressed: () {
                setState(() {
                  tagBox.delete(key);
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

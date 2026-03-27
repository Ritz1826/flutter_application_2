import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/data_model/hive_boxes/user_notes.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  Future<void> openNotesDialog({
    bool isEdit = false,
    UserNotes? editData,
  }) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text("   Cancel   "),
            ),
            ElevatedButton(
              onPressed: () async {
                final Box box = Hive.box<UserNotes>("user_notes");

                if (isEdit && editData != null) {
                  print("am i here");
                  editData.title = titleController.text;
                  editData.description = descController.text;

                  editData.timeStamp = DateTime.now();

                  await editData.save();
                  context.pop();
                  return;
                }

                await box.put(
                  DateTime.now().toIso8601String(),
                  UserNotes(
                    title: titleController.text,
                    description: descController.text,
                    timeStamp: DateTime.now(),
                  ),
                );
                context.pop();
              },
              child: Text("   Save   "),
            ),
          ],
          constraints: BoxConstraints(maxHeight: 470, minWidth: 350),
          content: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Add your notes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextFormField(
                decoration: InputDecoration(hintText: "Add title"),
                controller: titleController,
              ),
              SizedBox(height: 30),
              TextFormField(
                maxLines: 4,
                controller: descController,
                decoration: InputDecoration(hintText: "Add Description"),
              ),
              SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings"),
        leading: IconButton(
          onPressed: () => context.canPop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNotesDialog(),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box<UserNotes>("user_notes").listenable(),
            builder: (context, value, child) {
              return Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    UserNotes data = value.values.toList()[index];
                    return Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(data.title),
                            subtitle: Text(data.description),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await data.delete();
                          },
                          icon: Icon(Icons.delete),
                        ),

                        IconButton(
                          onPressed: () {
                            titleController.text = data.title;
                            descController.text = data.description;

                            openNotesDialog(editData: data, isEdit: true);
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: value.length,
                ),
              );
            },
          ),

          Hero(
            tag: "hey1",
            child: Lottie.asset(
              'assets/animations/Aeroplane.json',
              height: 300,
              width: 600,
            ),
          ),
        ],
      ),
    );
  }
}

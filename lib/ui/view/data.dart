import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/data_model/user_posts_model.dart';
import 'package:flutter_application_2/ui/view_model/university_data_vm.dart';
import 'package:flutter_application_2/ui/view_model/user_posts_vm.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _Data();
}

class _Data extends State<Data> {
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  context.read<UserPostsVm>().getAndSetPosts();
      context.read<UniversityDataVm>().getAndSetUniversityData();
    });

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserPostsVm, ({bool isLoading, List<UsersPosts>? posts})>(
      selector: (_, vm) =>
          (isLoading: vm.arePostsLoading, posts: vm.allUsersPosts),
      builder: (context, value, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: Text("data")),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(),

                      itemCount: value.posts?.length ?? 1,

                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(value.posts?[index].title ?? ""),
                        );
                      },
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: titleController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Enter your post",
                          ),
                          onChanged: (value) {
                            context.read<UserPostsVm>().userTitle = value;
                          },
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<UserPostsVm>().getAndSetTitle();
                          titleController.clear();
                        },
                        icon: Icon(Icons.post_add),
                        label: Text("post"),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print("Button tapped");
                      ImagePicker imgPicker = ImagePicker();

                      XFile? file = await imgPicker.pickImage(
                        source: ImageSource.camera,
                      );
                      print("myyy img " + file.toString());

                      print(
                        "myyy img 2 " +
                            (file?.path.runtimeType.toString() ?? ""),
                      );

                      if (file == null) return;

                      context.read<UserPostsVm>().imgFile = file;
                      context.read<UserPostsVm>().filePath = file?.path;

                      context.read<UserPostsVm>().getAndSetImg();
                    },
                    child: Text("select image"),
                  ),

                  Selector<UserPostsVm, String?>(
                    selector: (x, y) => y.img,
                    builder: (context, value, child) {
                      return value == null
                          ? SizedBox.shrink()
                          : Image.network(value, height: 100, width: 100);
                    },
                  ),
                ],
              ),
            ),

            Visibility(
              visible: value.isLoading,
              child: Container(
                color: Colors.black.withAlpha(198),
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      //   color: Colors.deepPurple,
                      strokeWidth: 10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

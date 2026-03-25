import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/ui/core/api_helpers/debounce_helper.dart';
import 'package:flutter_application_2/ui/core/api_helpers/polling_helper.dart';
import 'package:flutter_application_2/ui/data_model/userImages_data_model.dart';
import 'package:flutter_application_2/ui/view_model/user_images_vm.dart';
import 'package:provider/provider.dart';

class UserImages extends StatefulWidget {
  const UserImages({super.key});

  @override
  State<UserImages> createState() => _UserImagesState();
}

class _UserImagesState extends State<UserImages> {
  TextEditingController inputController = TextEditingController();
  ScrollController gridScroller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<UserImagesVm>();
      //  await vm.getAndSetUserImages();

      PollingHelper(
        interval: Duration(seconds: 10),
        function: () => vm.getAndSetUserImages(),
        scroller: gridScroller,
      ).startPolling();

      gridScroller.addListener(() async {
        if (gridScroller.position.pixels ==
                gridScroller.position.maxScrollExtent ||
            gridScroller.position.pixels >
                    gridScroller.position.maxScrollExtent &&
                gridScroller.position.userScrollDirection ==
                    ScrollDirection.reverse &&
                !vm.isPaginatedLoading) {
          await vm.getAndSetUserImages();
        }
      });
    });

    super.initState();
  }

  final DebounceHelper debounceHelper = DebounceHelper();

  void dispose() {
    gridScroller.dispose();
    inputController.dispose();
    debounceHelper.timerDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<
      UserImagesVm,
      ({
        List<UserImageData>? imagesData,
        bool isLoading,
        bool isPaginatedLoading,
      })
    >(
      selector: (x, y) => (
        imagesData: y.userImagesData,
        isLoading: y.isInitialLoading,
        isPaginatedLoading: y.isPaginatedLoading,
      ),

      builder: (context, value, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: Text("Images")),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 80,
                      child: ValueListenableBuilder(
                        valueListenable: inputController,
                        builder: (context, value, child) {
                          return TextFormField(
                            controller: inputController,
                            maxLength: 100,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                            ],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if ((value?.length ?? 1) < 3) {
                                return "Enter atleast 3 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Search for image",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                              constraints: BoxConstraints(
                                minHeight: 80,
                                maxHeight: 80,
                              ),
                              // icon: Icon(Icons.abc),
                              suffixIcon: inputController.value.text.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        inputController.clear();
                                        context
                                            .read<UserImagesVm>()
                                            .getAndSetUserImages(
                                              isRefresh: true,
                                            );
                                      },
                                      child: Icon(Icons.clear),
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              debounceHelper.callFunction(() {
                                context
                                    .read<UserImagesVm>()
                                    .getAndSetUserImages(
                                      isSearching: true,
                                      query1: value,
                                    )
                                    .then((_) {
                                      if (gridScroller.hasClients) {
                                        gridScroller.animateTo(
                                          0,
                                          duration: Duration(milliseconds: 1),
                                          curve: Curves.bounceIn,
                                        );
                                      }
                                    });
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Expanded(
                    child: (value.imagesData?.isEmpty ?? true)
                        ? Text("No data")
                        : RefreshIndicator(
                            onRefresh: () async {
                              await context
                                  .read<UserImagesVm>()
                                  .getAndSetUserImages(isRefresh: true);
                            },
                            child: GridView.builder(
                              physics: ClampingScrollPhysics(),
                              controller: gridScroller,
                              itemCount: value.imagesData?.length ?? 0,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    mainAxisExtent: 230,
                                  ),
                              itemBuilder: (context, index) {
                                return Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  margin: EdgeInsets.all(10),

                                  child: Column(
                                    children: [
                                      Image.network(
                                        value.imagesData?[index].url ?? "",
                                        height: 150,
                                        width: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                SizedBox(
                                                  height: 150,
                                                  width: 200,
                                                ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          value.imagesData?[index].title ?? "",
                                          style: TextStyle(fontSize: 10),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ),

                  Visibility(
                    visible: value.isPaginatedLoading,
                    child: Container(
                      height: 45,
                      width: 25,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: CircularProgressIndicator(
                        //   color: Colors.deepPurple,
                        strokeWidth: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Visibility(
              visible: value.isLoading,
              child: Center(
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
            ),
          ],
        );
      },
    );
  }
}

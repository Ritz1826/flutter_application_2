import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_2/ui/data_model/university_data_model.dart';
import 'package:flutter_application_2/ui/view_model/university_data_vm.dart';
import 'package:provider/provider.dart';

class UniversityDataPage extends StatefulWidget {
  const UniversityDataPage({super.key});

  @override
  State<UniversityDataPage> createState() => _UniversityDataState();
}

class _UniversityDataState extends State<UniversityDataPage> {
  ScrollController listScrollController = ScrollController();

  // bool isLoadingg = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UniversityDataVm>().getAndSetUniversityData();

      // listScrollController.addListener(() {
      //   final position = listScrollController.position;

      //   if (
      //   //position.userScrollDirection == ScrollDirection.reverse &&
      //   !context.read<UniversityDataVm>().paginationLoading &&
      //       position.pixels > position.maxScrollExtent - 100) {
      //     context.read<UniversityDataVm>().getAndSetUniversityData();
      //   }
      // });
    });

    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Selector<
      UniversityDataVm,
      ({List<User>? userData, bool isLoading, bool isMoreLoading})
    >(
      selector: (x, y) => (
        userData: y.userUniversityData,
        isLoading: y.initialLoading,
        isMoreLoading: y.paginationLoading,
      ),
      builder: (context, value, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: Text("University Data")),
              body: Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (!context
                                .read<UniversityDataVm>()
                                .paginationLoading &&
                            notification.metrics.pixels >
                                notification.metrics.maxScrollExtent - 100) {
                          context
                              .read<UniversityDataVm>()
                              .getAndSetUniversityData();
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<UniversityDataVm>()
                              .getAndSetUniversityData(isRefresh: true);
                        },
                        child: ListView.separated(
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            //  print(value.userData?.length ?? 0);
                            return ListTile(
                              title: Text(
                                '${value.userData?[index].firstName}  $index' ??
                                    "",
                              ),
                              subtitle: Text(
                                value.userData?[index].address.city ?? "",
                              ),
                            );
                          },

                          controller: listScrollController,
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: value.userData?.length ?? 0,
                        ),
                      ),
                    ),
                  ),

                  value.isMoreLoading
                      ? CircularProgressIndicator(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          constraints: BoxConstraints(
                            maxHeight: 30,
                            minHeight: 30,
                            maxWidth: 30,
                            minWidth: 30,
                          ),
                          strokeWidth: 6,
                        )
                      : SizedBox.shrink(),
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

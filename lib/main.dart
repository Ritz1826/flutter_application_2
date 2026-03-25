import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/data_model/university_data_model.dart';
import 'package:flutter_application_2/ui/view/animations.dart';
import 'package:flutter_application_2/ui/view/data.dart';
import 'package:flutter_application_2/ui/view/form_widgets/university_data.dart';
import 'package:flutter_application_2/ui/view/home.dart';
import 'package:flutter_application_2/ui/view/home_layout.dart';
import 'package:flutter_application_2/ui/view/images.dart';
import 'package:flutter_application_2/ui/view/profile.dart';
import 'package:flutter_application_2/ui/view/settings.dart' show Settings;
import 'package:flutter_application_2/ui/view_model/university_data_vm.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:flutter_application_2/ui/view_model/user_images_vm.dart';
import 'package:flutter_application_2/ui/view_model/user_posts_vm.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(300, 600),
      minTextAdapt: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserFormVm()),

          ChangeNotifierProvider(create: (context) => UniversityDataVm()),

          ChangeNotifierProvider(create: (context) => UserPostsVm()),

          ChangeNotifierProvider(create: (context) => UserImagesVm()),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',

          theme: ThemeData(
            primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          routerConfig: GoRouter(
            initialLocation: "/profile",

            routes: [
              GoRoute(
                path: "/settings",
                builder: (context, state) => Settings(),
              ),

              StatefulShellRoute.indexedStack(
                builder: (context, state, navigationShell) {
                  return HomeLayout(navigationShell: navigationShell);
                },

                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: "/userImages",
                        builder: (context, state) => UserImages(),
                      ),
                    ],
                  ),

                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: "/universityData",
                        builder: (context, state) => UniversityDataPage(),
                      ),
                    ],
                  ),

                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: "/data",
                        builder: (context, state) => Data(),
                      ),
                    ],
                  ),

                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: "/animations",
                        builder: (context, state) => AnimationsView(),
                      ),
                    ],
                  ),

                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: "/home",
                        builder: (context, state) => Home(),
                      ),
                    ],
                  ),

                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: "/profile",
                        builder: (context, state) => Profile(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

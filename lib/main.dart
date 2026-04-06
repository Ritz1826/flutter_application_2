import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/core/app_consts/app_consts.dart';
import 'package:flutter_application_2/ui/data_model/hive_boxes/user_notes.dart';
import 'package:flutter_application_2/ui/view/animations.dart';
import 'package:flutter_application_2/ui/view/data.dart';
import 'package:flutter_application_2/ui/view/form_widgets/university_data.dart';
import 'package:flutter_application_2/ui/view/helpers/notif_service.dart';
import 'package:flutter_application_2/ui/view/home.dart';
import 'package:flutter_application_2/ui/view/home_layout.dart';
import 'package:flutter_application_2/ui/view/images.dart';
import 'package:flutter_application_2/ui/view/otp_screen.dart';
import 'package:flutter_application_2/ui/view/phone_screen.dart';
import 'package:flutter_application_2/ui/view/profile.dart';
import 'package:flutter_application_2/ui/view/notes.dart' show Settings, Notes;
import 'package:flutter_application_2/ui/view/signin_screen.dart';
import 'package:flutter_application_2/ui/view/signup_screen.dart';
import 'package:flutter_application_2/ui/view/splash_screen.dart';
import 'package:flutter_application_2/ui/view_model/university_data_vm.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:flutter_application_2/ui/view_model/user_images_vm.dart';
import 'package:flutter_application_2/ui/view_model/user_posts_vm.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();

  await NotifService().initNotifPlugin();

  Hive.registerAdapter(UserNotesAdapter());

  await Hive.openBox<UserNotes>("user_notes");

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
            navigatorKey: AppConsts.navigatorKey,
            // errorBuilder: (context, state) {
            //   return PhoneSignupScreen();
            // },
            initialLocation: "/phonesignup",

            routes: [
              GoRoute(path: "/notes", builder: (context, state) => Notes()),

              GoRoute(
                name: "splash",
                path: "/splash",
                builder: (context, state) => SplashScreen(),
              ),

              GoRoute(
                name: "signup",
                path: "/signup",
                builder: (context, state) => SignupScreen(),
              ),

              GoRoute(
                name: "signin",
                path: "/signin",
                builder: (context, state) => SigninScreen(),
              ),

              GoRoute(
                path: '/__/auth/callback',
                builder: (context, state) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                },
              ),

              GoRoute(
                path: '/:pathMatch(.*)*',
                builder: (context, state) {
                  return const Scaffold(
                    body: Center(child: Text('Redirecting...')),
                  );
                },
              ),

              // GoRoute(
              //   name: "/",
              //   path: "/",
              //   builder: (context, state) => PhoneSignupScreen(),
              // ),
              GoRoute(
                name: "otpscreen",
                path: "/otpscreen",
                builder: (context, state) =>
                    OtpScreen(gotVerificationId: state.extra as String),
              ),

              GoRoute(
                name: "phonesignup",
                path: "/phonesignup",
                builder: (context, state) => PhoneSignupScreen(),
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
                        name: 'profile',
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

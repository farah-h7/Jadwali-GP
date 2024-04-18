import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:jadwali_test_1/auth/auth_service.dart';
import 'package:jadwali_test_1/auth/child_auth.dart';
import 'package:jadwali_test_1/db/db_helper.dart';
import 'package:jadwali_test_1/modules/child.dart';
import 'package:jadwali_test_1/pages/Common/createAccount_child.dart';
import 'package:jadwali_test_1/pages/Child/home_child.dart';
import 'package:jadwali_test_1/pages/Common/login_child.dart';
import 'package:jadwali_test_1/pages/Parent/home_parent.dart';
import 'package:jadwali_test_1/pages/Common/login_parent.dart';
import 'package:jadwali_test_1/pages/Common/pre_login.dart';
import 'package:jadwali_test_1/providers/Schedule_provider.dart';
import 'package:jadwali_test_1/providers/child_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Child? currentChild;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => childProvider()),
      ChangeNotifierProvider(create: (context)=> ScheduleProvider()),
    ],
    child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
//}

final _router = GoRouter(
  
  initialLocation: PreLogin.routeName,
  debugLogDiagnostics: true,//show routes in consol

  // redirect: (context, state) {
  //   //check current user, or if a user is logged in
  //   if (AuthService.currentUser == null) {
  //     //return LoginParent.routeName;
  //     return PreLogin.routeName;
  //   }
  //   return null; // it will not redirect to login page and go streight to homepage
  // },
  redirect:(context, state) async {
          

    if (AuthService.currentUser != null){
      //AuthService.logout();
      if (await DbHelper.isP(AuthService.currentUser!.uid)){

        return HomeParent.routeName;
        }
      else {
        String code = await AuthService.getcurrentusercode();
            
        currentChild = await childAuth().getChildWithSpecificUcode(code) as Child;
        return homeChild.routeName;
                                          
      }
     }
    return null;
  },
  routes: [
    GoRoute(
      name: HomeParent.routeName,
      path:  HomeParent.routeName,
      builder: (context, state) => const HomeParent(),
    ),
    GoRoute(
        name: PreLogin.routeName,
        path: PreLogin.routeName,
        builder: (context, state) => const PreLogin(),
        routes: [
          GoRoute(
            name: LoginParent.routeName,
            path: LoginParent.routeName,
            builder: (context, state) => const LoginParent(),
          ),
          GoRoute(
            name: LoginChild.routeName,
            path: LoginChild.routeName,
            builder: (context, state) => const LoginChild(),
            routes: [
              GoRoute(
            name: CreateChildUser.routeName,
            path: CreateChildUser.routeName,
            builder: (context, state) => const CreateChildUser(),
          ),
            ]
          ),
        ]
        ),
      GoRoute(
      name: homeChild.routeName,
      path:  homeChild.routeName,
      builder: (context, state) =>  homeChild(user: currentChild!,),
    ),
        // GoRoute(
        //     name: LoginParent.routeName,
        //     path: LoginParent.routeName,
        //     builder: (context, state) => const LoginParent(),
        //   )
  ],
  
);
}
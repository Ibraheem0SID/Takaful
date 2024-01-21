import 'package:data_table_try/data/enums.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/Roles/roles.dart';
import 'features/Roles/roles_MV.dart';
import 'features/dash_bord/cities/cities_mv.dart';
import 'features/dash_bord/dash_bord.dart';
import 'features/dash_bord/dash_bord_mv.dart';
import 'features/dash_bord/deleted families/deleted_families_mv.dart';
import 'features/data table/gpt_table.dart';
import 'features/data table/gpt_tableMV.dart';
import 'features/family_details/family_details_mv.dart';
import 'features/login/log_in.dart';
import 'features/login/login_mv.dart';
import 'features/new_family/add_family_mv.dart';
import 'features/profile/profile.dart';
import 'features/profile/profile_MV.dart';
import 'util/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs().init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoginMV()),
    ChangeNotifierProvider(create: (_) => ProfileMV()),
    ChangeNotifierProvider(create: (_) => RolesMV()),
    ChangeNotifierProvider(create: (_) => GptTableMV()),
    ChangeNotifierProvider(create: (_) => DashBordMV()),
    ChangeNotifierProvider(create: (_) => AddFamilyMv()),
    ChangeNotifierProvider(create: (_) => FamilyDetailsMV()),
    ChangeNotifierProvider(create: (_) => CitiesMV()),
    ChangeNotifierProvider<DeletedFamiliesMV>(
        create: (_) => DeletedFamiliesMV()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 1;
  List pages = [
    GptTable(),
    DashBord(),
    Profile(),
    if (Prefs().userRole == UserRole.superAdmin) Roles(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: Colors.grey[300],
        fontFamily: 'Tajwal',
        scaffoldBackgroundColor: Colors.grey[300],
        dialogBackgroundColor: Colors.grey[300],
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      home: Prefs().token == null
          ? Login()
          : Scaffold(
              body: pages[index],
              bottomNavigationBar: FlashyTabBar(
                backgroundColor: Colors.grey[300],
                selectedIndex: index,
                showElevation: true,
                onItemSelected: (i) => setState(() {
                  index = i;
                }),
                items: [
                  FlashyTabBarItem(
                    icon: Icon(Icons.family_restroom_outlined),
                    title: Text('العوائل'),
                  ),
                  FlashyTabBarItem(
                    icon: Icon(Icons.home),
                    title: Text('الرئيسية'),
                  ),
                  FlashyTabBarItem(
                    icon: Icon(Icons.account_circle_rounded),
                    title: Text('بروفايل'),
                  ),
                  if (Prefs().userRole == UserRole.superAdmin)
                    FlashyTabBarItem(
                      icon: Icon(Icons.manage_accounts),
                      title: Text('الاعضاء'),
                    ),
                ],
                animationDuration: Duration(milliseconds: 300),
              ),
            ),
    );
  }
}

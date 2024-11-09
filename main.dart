import 'controllers/google_sheets_api.dart';
import 'controllers/sheet_values.dart';
import 'home_page.dart';
import 'controllers/user_theme.dart';
import 'stats_page/read_sheet.dart';
import 'welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const ScoutingApp());
}

UserTheme ut = Get.put(UserTheme());
SheetValues sv = Get.put(SheetValues());

loading({required RxBool finished}) async {
  bool canBoot = true;
  List listOfFields = [];
  // List listOfRegionals = [];
  // List listOfDistricts = [];
  // makes sure you have a connection with the sheet
  //calls for the initialization meathod for the sheet
  await GoogleSheetsApi().init();
  // https://fluttercentral.com/Articles/Post/1242/How_to_the_set_change_status_bar_or_system_navigation_bar_color_in_Flutter
  //THE LORD HAS CLUTCHED
  //the line under this waits for the screen size to be init
  await ScreenUtil.ensureScreenSize();

  WidgetsFlutterBinding.ensureInitialized();
  // var regtionalEvents = await getAllRegionalEvents();
  // var districtEvents = await getAllDistrictEvents();
  // sv.regionalEventsMap.value = regtionalEvents;
  // sv.districtEventsMap.value = districtEvents;
  // listOfRegionals = regtionalEvents.keys.toList();
  // listOfDistricts = districtEvents.keys.toList();
  // listOfRegionals.sort();
  // listOfDistricts.sort();
  // sv.regionalEventNames.value = listOfRegionals;
  // sv.districtEventNames.value = listOfDistricts;
  // sv.events.value = sv.regionalEventNames;

  listOfFields = sv.worldsFieldsMap.keys.toList();
  listOfFields.sort();
  sv.worldsFieldsNames.value = listOfFields;
  sv.events.value = sv.worldsFieldsNames;

  if (sv.pref.read('booted') == true) {
    sv.scoutName.text = sv.pref.read('scouters name');
    sv.scoutersTeam.text = sv.pref.read('scouters team');
    if (sv.pref.read('team only data') == true ||
        sv.pref.read('team only data') == false) {
      sv.wantsTeamOnlyStats.value = sv.pref.read('team only data');
      sv.wantsTeamOnlyStats.value == true
          ? sv.switchIcon.value = sv.switchIcon2
          : sv.switchIcon.value = sv.switchIcon1;
      if (sv.pref.read('selected a field') == true) {
        sv.eventListHint.value = sv.pref.read('selected event name');
        sv.eventKey.value = sv.pref.read('event key');
        sv.selectedAnEvent.value = sv.pref.read('selected event?');

        canBoot = true;
      } else {
        canBoot = false;
      }

      var matches = await getEventMatches();
      var teamsAtEvent = await eventTeams();

      List teamMatches = matches.keys.toList();
      teamMatches.sort();
      sv.matches.value = teamMatches;

      var sortTeamList = teamsAtEvent.keys.toList();
      sortTeamList.sort();
      sv.teamXList.value = sortTeamList;
      sv.eventTeams.value = teamsAtEvent;
      Future.delayed(const Duration(seconds: 2));

      if (canBoot == true) {
        Get.off(() => const HomePage());
      } else {
        Get.off(() => const WelcomePage());
      }
    } else {
      Get.off(() => const WelcomePage());
    }
  } else {
    Get.off(() => const WelcomePage());
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool finished = false.obs;
    loading(finished: finished);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 300.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                height: 200.h,
                image:
                    const AssetImage("lib/assets/Cyber Vipers Logo 2023.png"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.h),
                child: const Text(
                  "Ssscouting App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoSans',
                      fontSize: 25),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ScoutingApp extends StatelessWidget {
  const ScoutingApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.grey[850],
        systemNavigationBarColor: Colors.grey[850],
      ),
    );
    return ScreenUtilInit(
      builder: (_, child) => SafeArea(
        child: GetMaterialApp(
          theme: ut.currentTheme,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
      designSize: const Size(360, 850),
    );
  }
}

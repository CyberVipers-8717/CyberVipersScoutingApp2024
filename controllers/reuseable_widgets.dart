import 'sheet_values.dart';
import 'user_theme.dart';
import '../home_page.dart';
import '../stats_page/read_sheet.dart';
import '../scouting_pages/scouting_page.dart';
import '../stats_page/stats_fields.dart';
import '../stats_page/stats_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ReuseWid extends GetxController {
  RxInt selectedIndex = 0.obs;
  UserTheme ut = Get.find();
  SheetValues sv = Get.put(SheetValues());
  StatsFields sf = Get.put(StatsFields());
  TextEditingController event = TextEditingController();

  notesFromWhere() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Notes From Where',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'NotoSans',
            fontSize: 28,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Floor',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'NotoSans',
                fontSize: 23,
              ),
            ),
            Obx(
              () => Switch.adaptive(
                activeTrackColor: ut.buttonColor.value,
                trackOutlineColor: const MaterialStatePropertyAll(Colors.white),
                value: sv.notesFromSource.value,
                onChanged: (value) {
                  if (sv.notesFromSource.value == false) {
                    sv.notesFromSource.value = true;
                    sv.switchIcon.value = sv.switchIcon2;
                  } else {
                    sv.notesFromSource.value = false;

                    sv.switchIcon.value = sv.switchIcon1;
                  }
                },
              ),
            ),
            const Text(
              'Source',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'NotoSans',
                fontSize: 23,
              ),
            ),
          ],
        )
      ],
    );
  }

  textForGraph({required String name}) {
    return Text(
      name,
      style: const TextStyle(
          fontFamily: 'NotoSans',
          fontSize: 18,
          color: Colors.white,
          letterSpacing: 1.6),
    );
  }

  line() {
    return Container(
      height: 1.5,
      color: Colors.white,
    );
  }

  teaminfo() {
    return Center(
      child: Text(
        'Team ${sv.teamNum} - Match ${sv.matchNum}',
        style: const TextStyle(
            fontFamily: 'NotoSans', color: Colors.white, fontSize: 25),
      ),
    );
  }

  drawerWid({required String title, required function, required icon}) {
    return ElevatedButton(
      onPressed: function,
      style: const ButtonStyle(
          padding: MaterialStatePropertyAll(EdgeInsets.fromLTRB(15, 16, 0, 16)),
          backgroundColor: MaterialStatePropertyAll(Color(0x00FFFFFF)),
          splashFactory: InkSplash.splashFactory,
          overlayColor:
              MaterialStatePropertyAll(Color.fromARGB(225, 176, 171, 171)),
          elevation: MaterialStatePropertyAll(0)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon,
          const SizedBox(
            width: 12,
          ),
          Obx(
            () => Text(title,
                style: const TextStyle(
                    fontSize: 25, color: Colors.white, fontFamily: 'NotoSans')),
          ),
          const SizedBox(
            height: double.minPositive,
            width: double.minPositive,
          )
        ],
      ),
    );
  }

  valueToggle(
      {required RxBool value,
      required String title,
      required double width,
      required double height,
      required Rx<Color> fillColor}) {
    return InkWell(
      splashFactory: InkSplash.splashFactory,
      splashColor: Colors.grey[300],
      borderRadius: BorderRadius.circular(18.r),
      onTap: () {
        if (value.value == true) {
          value.value = false;
          fillColor.value = Colors.transparent;
        } else {
          value.value = true;
          fillColor.value = ut.buttonColor.value;
        }
      },
      child: Obx(
        () => Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: ut.buttonColor.value, width: 4.w),
              color: fillColor.value),
          width: width,
          height: height,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 30, fontFamily: 'NotoSans'),
            ),
          ),
        ),
      ),
    );
  }

  statsType() {
    return Column(
      children: [
        const Text(
          'Team Only Data',
          style: TextStyle(
              color: Colors.white, fontFamily: 'NotoSans', fontSize: 25),
        ),
        Obx(
          () => Switch.adaptive(
            activeTrackColor: Colors.red,
            thumbIcon: sv.switchIcon.value,
            trackOutlineColor: const MaterialStatePropertyAll(Colors.white),
            value: sv.wantsTeamOnlyStats.value,
            onChanged: (value) {
              if (sv.wantsTeamOnlyStats.value == false) {
                sv.wantsTeamOnlyStats.value = true;
                sv.switchIcon.value = sv.switchIcon2;
              } else {
                sv.wantsTeamOnlyStats.value = false;

                sv.switchIcon.value = sv.switchIcon1;
              }
              sv.pref.write('team only data', sv.wantsTeamOnlyStats.value);
            },
          ),
        )
      ],
    );
  }

  toggleEventType() {
    String tapForDistricts = 'Tap to see District Events';
    String tapForRegionals = 'Tap to see Regional Events';
    RxString eventHint = 'Tap to see District Events'.obs;
    String regionalListHint = 'Select Regional';
    String districtListHint = 'Select District';

    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      splashColor: Colors.grey[350],
      splashFactory: InkRipple.splashFactory,
      onTap: () {
        if (sv.isDistrict.isFalse) {
          sv.isDistrict.value = true;
          eventHint.value = tapForRegionals;
          sv.events.value = sv.districtEventNames;
          sv.eventListHint.value = districtListHint;
        } else {
          sv.isDistrict.value = false;
          eventHint.value = tapForDistricts;
          sv.events.value = sv.regionalEventNames;
          sv.eventListHint.value = regionalListHint;
        }
        sv.teamListHint.value = 'Select A Team To View';
        sv.selectedAnEvent.value = false;
      },
      child: Ink(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2.w),
            borderRadius: BorderRadius.circular(15.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          child: Obx(
            () => Text(
              eventHint.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 25, fontFamily: 'NotoSans', color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  eventDropDown() {
    return Obx(
      () => DropdownButton2(
        underline: const SizedBox(),
        isExpanded: true,
        hint: Text(
          '      ${sv.eventListHint}',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'NotoSans',
            fontSize: 15,
          ),
        ),
        onChanged: (value) async {
          sv.eventListHint.value = value!;
          sv.selectMatch.value = 'Select a Match';
          sv.selectedAMatch.value = false;
          sf.clearView();
          // if (sv.isDistrict.isFalse) {
          //   sv.eventKey.value = sv.regionalEventsMap[value];
          // } else {
          //   sv.eventKey.value = sv.districtEventsMap[value];
          // }
          sv.eventKey.value = sv.worldsFieldsMap[value];
          var matches = await getEventMatches();
          List matchNums = matches.keys.toList();
          matchNums.sort();
          sv.matches.value = matchNums;

          sv.pref.write('event key', sv.eventKey.value);
          sv.pref.write('selected event?', sv.selectedAnEvent.value);
          sv.pref.write('selected event name', sv.eventListHint.value);

          sv.pref.write('selected a field', true);

          var thing = await eventTeams();
          var sortTeamList = thing.keys.toList();
          sortTeamList.sort();
          sv.teamXList.value = sortTeamList;
          sv.eventTeams.value = thing;

          sv.teamListHint.value = 'Select A Team To View';

          sv.selectedAnEvent.value = true;
        },
        items: sv.events
            .map((dynamic event) => DropdownMenuItem<String>(
                  value: event,
                  child: Text(
                    event,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'NotoSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                ))
            .toList(),
        alignment: Alignment.center,
        iconStyleData: const IconStyleData(iconEnabledColor: Colors.white),
        dropdownStyleData: DropdownStyleData(
          scrollbarTheme: const ScrollbarThemeData(
              thumbColor: MaterialStatePropertyAll(Colors.grey)),
          maxHeight: 400.h,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
        ),
        buttonStyleData: ButtonStyleData(
          width: 200.w,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
      ),
    );
  }

  d() {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.grey[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            // toggleEventType(),
            const Center(
              child: Text(
                'Select a Field',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoSans',
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              child: Center(
                child: SizedBox(
                  width: 200.w,
                  child: eventDropDown(),
                ),
              ),
            ),
            Center(
              child: statsType(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => launchUrl(
                          mode: LaunchMode.externalApplication,
                          Uri.parse(
                              'https://drive.google.com/drive/folders/14D17j5ANKq0OcgsYpS1qCAYZtc1uqhSb'),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 16.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            const Text(
                              'About',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'NotoSans'),
                            )
                          ],
                        ),
                      ),
                      const Text(
                        'Version 1.5',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ab({required String title}) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontSize: 25, fontFamily: 'NotoSans'),
      ),
    );
  }

  bnb() {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[850],
      iconSize: 28,
      elevation: 0,
      currentIndex: selectedIndex.value,
      onTap: (index) async {
        selectedIndex.value = index;
        switch (index) {
          case 0:
            Get.off(() => const HomePage());
          case 1:
            if (sv.scoutName.text.isBlank! || sv.scoutersTeam.isBlank!) {
              ut.tfc.value = Colors.red;
              await Future.delayed(const Duration(milliseconds: 250));
              ut.tfc.value = Colors.white;
              await Future.delayed(const Duration(milliseconds: 250));
              ut.tfc.value = Colors.red;
              await Future.delayed(const Duration(milliseconds: 250));
              ut.tfc.value = Colors.white;
            } else {
              Get.off(() => const ScoutingPage());
            }
          case 2:
            if (sv.selectedAnEvent.isTrue) {
              if (sv.alreadyInStats.isFalse) {
                sv.statsWantsBlue.value = true;
                ut.buttonColor.value = const Color.fromARGB(255, 0, 101, 179);
              } else {
                if (sv.statsWantsBlue.isFalse) {
                  ut.buttonColor.value = const Color.fromARGB(255, 237, 52, 52);
                } else {
                  ut.buttonColor.value = const Color.fromARGB(255, 0, 101, 179);
                }
              }
              Get.to(() => const StatsPage());
            }
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.content_paste),
          label: 'Scout',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Stats',
        ),
      ],
    );
  }

  nameField() {
    return SizedBox(
      width: 190.w,
      child: Obx(
        () => TextField(
          onChanged: (value) {
            sv.pref.write('scouters name', value);
          },
          autocorrect: false,
          controller: sv.scoutName,
          textAlign: TextAlign.center,
          enabled: true,
          cursorColor: Colors.white,
          style: const TextStyle(
              color: Colors.white, fontFamily: 'NotoSans', fontSize: 20),
          decoration: InputDecoration(
            alignLabelWithHint: false,
            label: Center(
              child: Text(
                'Name',
                style: TextStyle(
                    color: ut.ts, fontFamily: 'NotoSans', fontSize: 20),
              ),
            ),
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(color: ut.tfc.value, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(color: ut.tfc.value, width: 2)),
          ),
        ),
      ),
    );
  }
}

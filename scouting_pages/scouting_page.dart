import '../controllers/reuseable_widgets.dart';
import '../controllers/sheet_values.dart';
import '../scouting_pages/auto_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScoutingPage extends StatelessWidget {
  const ScoutingPage({super.key});
  @override
  Widget build(BuildContext context) {
    SheetValues sv = Get.put(SheetValues());
    ReuseWid rw = Get.put(ReuseWid());

    RxBool selectedBlueAlliance = false.obs;

    RxString team1 = ''.obs;
    RxString team2 = ''.obs;
    RxString team3 = ''.obs;

    RxString localAlliacne = ''.obs;
    RxString localMatch = ''.obs;
    RxString localTeam = ''.obs;
    RxString localTeamName = ''.obs;

    teamInMatch(
        {required RxString text,
        required RxString teamNumber,
        required RxString teamName}) {
      return InkWell(
        borderRadius: BorderRadius.circular(20.r),
        splashColor: Colors.grey,
        onTap: () {
          if (text.isNotEmpty) {
            sv.teamNum.value = int.parse(text.value);
            int teamNum = sv.teamNum.value;
            teamNumber.value = teamNum.toString();
            String? findTeamName = sv.eventTeams[teamNum];
            if (findTeamName != null) {
              teamName.value = findTeamName;
            } else {
              teamName.value = 'No Team Found';
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                showCloseIcon: true,
                backgroundColor: Colors.grey[800],
                content: const Text(
                  'No Match Selected',
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }
        },
        child: Container(
          width: 80.w,
          height: 60.h,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2.w),
              borderRadius: BorderRadius.circular(20.r)),
          child: Center(
            child: Obx(
              () => Text(
                text.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoSans',
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      drawer: rw.d(),
      appBar: rw.ab(title: 'Scouting Page'),
      body: ListView(
        shrinkWrap: true,
        children: [
          rw.line(),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Center(
              child: Obx(
                () => DropdownButton2(
                  underline: const SizedBox(),
                  value: sv.selectedValue,
                  hint: Text(
                    sv.matchHint.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoSans',
                      fontSize: 18,
                    ),
                  ),
                  onChanged: (value) {
                    team1.value = '';
                    team2.value = '';
                    team3.value = '';

                    localAlliacne.value = '';
                    localMatch.value = '';
                    localTeam.value = '';
                    localTeamName.value = '';
                    sv.matchHint.value = 'Match $value';
                    sv.matchNum.value = value;
                    sv.selectedValue = value;
                    localMatch.value = value.toString();
                    sv.selectedAMatch.value = true;
                  },
                  items: sv.matches
                      .map(
                        (dynamic matchNum) => DropdownMenuItem<dynamic>(
                          value: matchNum,
                          child: Text(
                            'Match $matchNum',
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'NotoSans',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ),
                      )
                      .toList(),
                  dropdownStyleData: DropdownStyleData(
                    useRootNavigator: true,
                    scrollbarTheme: ScrollbarThemeData(
                        radius: Radius.circular(20.r),
                        thumbColor:
                            const MaterialStatePropertyAll(Colors.grey)),
                    maxHeight: 400.h,
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(15.r)),
                  ),
                  iconStyleData:
                      const IconStyleData(iconEnabledColor: Colors.white),
                  buttonStyleData: ButtonStyleData(
                    elevation: 0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.w),
                        borderRadius: BorderRadius.circular(15.r)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    if (sv.selectedAnEvent.isTrue) {
                      if (sv.selectedAMatch.isTrue) {
                        int match = sv.matchNum.value;
                        List blueTeams = sv.allianceMatches[match]['blue'];
                        sv.alliance.value = 'Blue';
                        team1.value = blueTeams[0].substring(3);
                        team2.value = blueTeams[1].substring(3);
                        team3.value = blueTeams[2].substring(3);
                        selectedBlueAlliance.value = true;
                        localAlliacne.value = 'Blue';

                        ut.buttonColor.value =
                            const Color.fromARGB(255, 0, 101, 179);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            showCloseIcon: true,
                            backgroundColor: Colors.grey[800],
                            content: const Text(
                              'No Match Selected',
                              style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.grey[800],
                          content: const Text(
                            'No Event Selected',
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: const Color.fromARGB(255, 0, 101, 179),
                    ),
                    width: 150.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 18.h, horizontal: 0.5.w),
                      child: const Center(
                        child: Text(
                          'Blue Alliance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'NotoSans',
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (sv.selectedAnEvent.isTrue) {
                      if (sv.selectedAMatch.isTrue) {
                        int match = sv.matchNum.value;
                        List redTeams = sv.allianceMatches[match]['red'];
                        sv.alliance.value = 'Red';
                        team1.value = redTeams[0].substring(3);
                        team2.value = redTeams[1].substring(3);
                        team3.value = redTeams[2].substring(3);
                        selectedBlueAlliance.value = false;
                        localAlliacne.value = 'Red';
                        ut.buttonColor.value =
                            const Color.fromARGB(255, 237, 52, 52);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            showCloseIcon: true,
                            backgroundColor: Colors.grey[800],
                            content: const Text(
                              'No Match Selected',
                              style: TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.grey[800],
                          content: const Text(
                            'No Event Selected',
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: const Color.fromARGB(255, 237, 52, 52),
                    ),
                    width: 150.w,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 18.h, horizontal: 1.w),
                      child: const Center(
                        child: Text(
                          'Red Alliance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'NotoSans',
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: const Center(
              child: Text(
                'Select a Team',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'NotoSans', fontSize: 30),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              teamInMatch(
                  text: team1, teamNumber: localTeam, teamName: localTeamName),
              teamInMatch(
                  text: team2, teamNumber: localTeam, teamName: localTeamName),
              teamInMatch(
                  text: team3, teamNumber: localTeam, teamName: localTeamName),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Match',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    Obx(
                      () => Text(
                        '$localMatch',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Alliance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    Obx(
                      () => Text(
                        '$localAlliacne',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedBlueAlliance.value == true
                              ? Colors.blue
                              : Colors.red[400],
                          fontSize: 24,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Center(
              child: Obx(
                () => Text(
                  'Team: $localTeam',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontFamily: 'NotoSans',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: Obx(
              () => Text(
                'Team Name: $localTeamName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100.h,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                if (localTeam.isNotEmpty) {
                  team1.value = '';
                  team2.value = '';
                  team3.value = '';

                  localAlliacne.value = '';
                  localMatch.value = '';
                  localTeam.value = '';
                  localTeamName.value = '';

                  Get.to(() => const AutoStart());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      showCloseIcon: true,
                      backgroundColor: Colors.grey[800],
                      content: const Text(
                        'No Team Selected',
                        style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadiusDirectional.circular(18.r)),
                width: 180.w,
                height: 45.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: const Text(
                        'Auto',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'NotoSans',
                            fontSize: 25),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 28,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: rw.bnb(),
    );
  }
}

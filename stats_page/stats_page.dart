import '../controllers/reuseable_widgets.dart';
import '../controllers/sheet_values.dart';
import '../controllers/user_theme.dart';
import '../stats_page/stats_fields.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../stats_page/read_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

showAverage({required RxString value, required String title}) {
  return Column(
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'NotoSans',
          fontSize: 20,
        ),
      ),
      Container(
        width: 70.w,
        height: 55.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: Colors.white, width: 2)),
        child: Obx(
          () => Center(
            child: Text(
              value.value,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'NotoSans',
                fontSize: 18,
              ),
            ),
          ),
        ),
      )
    ],
  );
}

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ReuseWid rw = Get.put(ReuseWid());
    UserTheme ut = Get.find();
    SheetValues sv = Get.find();
    StatsFields sf = Get.put(StatsFields());

    return Scaffold(
      appBar: rw.ab(title: 'Stats Page'),
      drawer: rw.d(),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.black,
        onRefresh: () async {
          sv.viewAllScoutComment.value = [];
          sv.matchCommDropAva.value = false;
          sv.matchScouters.value = [];
          sf.scoutersDropdown.value = '';
          sv.commentCount.value = [];
          sf.clearView();
          var matchValues = await getDataForMatchNumber(
              team: sv.selectedTeamNumber.value.toString());

          if (matchValues.isNotEmpty) {
            var first = getAllAverageNumbers(made: 19);
            var second = getAllAverageNumbers(made: 21);
            var third = getAllAverageNumbers(made: 23);

            var autoAmpAv = getAllAverageNumbers(made: 15);
            var autoSpeakAv = getAllAverageNumbers(made: 17);

            var parkav = getBoolAverage(value: 33);
            var harmonyav = getBoolAverage(value: 34);

            int defav = seeAverageDefense();
            String strongest = getTeamStrongSuit();
            seeAllComments();

            sv.matchSpecStats.value = false;

            switch (defav) {
              case 1:
                sf.none.value = ut.buttonColor.value;
                break;
              case 2:
                sf.slight.value = ut.buttonColor.value;
                break;
              case 3:
                sf.modest.value = ut.buttonColor.value;
                break;
              case 4:
                sf.generous.value = ut.buttonColor.value;
                break;
              case 5:
                sf.exclusively.value = ut.buttonColor.value;
                break;
            }

            sf.stats1.value = first.toString();
            sf.stats2.value = second.toString();
            sf.stats3.value = third.toString();
            sf.autoAmp.value = autoAmpAv.toString();
            sf.autoSpeak.value = autoSpeakAv.toString();
            sf.parked.value = parkav;
            sf.harmony.value = harmonyav;
            sf.climb.value = climbAverage();
            sv.selectMatch.value = 'Select a Match';
            sf.strongSuit.value = strongest;
          } else {
            sv.teamMatches.value = [];
            sv.selectMatch.value = 'N/A';
            sf.stats1.value = 'N/A';
            sf.stats2.value = 'N/A';
            sf.stats3.value = 'N/A';
            sf.autoAmp.value = 'N/A';
            sf.autoSpeak.value = 'N/A';
            sf.parked.value = 'N/A';
            sf.harmony.value = 'N/A';
            sf.climb.value = 'N/A';
            sf.strongSuit.value = '?';
          }
        },
        child: ListView(
          children: [
            Center(
              child: Obx(
                () => DropdownButton2(
                  underline: const SizedBox(),
                  isExpanded: true,
                  hint: Obx(
                    () => Text(
                      '      ${sv.teamListHint}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'NotoSans',
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onChanged: (value) async {
                    sf.scoutersDropdown.value = '';
                    sv.viewAllScoutComment.value = [];
                    sv.matchCommDropAva.value = false;
                    sv.matchScouters.value = [];
                    sv.matchSpecStats.value = false;
                    sv.alreadyInStats.value = true;
                    sv.selectedTeamNumber.value = value!;
                    sv.teamListHint.value = '$value - ${sv.eventTeams[value]}';
                    sv.commentCount.value = [];
                    sf.clearView();
                    var matchValues =
                        await getDataForMatchNumber(team: value.toString());

                    if (matchValues.isNotEmpty) {
                      var first = getAllAverageNumbers(made: 19);
                      var second = getAllAverageNumbers(made: 21);
                      var third = getAllAverageNumbers(made: 23);

                      var autoAmpAv = getAllAverageNumbers(made: 15);
                      var autoSpeakAv = getAllAverageNumbers(made: 17);

                      var parkav = getBoolAverage(value: 33);
                      var harmonyav = getBoolAverage(value: 34);
                      int defav = seeAverageDefense();
                      String strongest = getTeamStrongSuit();
                      seeAllComments();

                      switch (defav) {
                        case 1:
                          sf.none.value = ut.buttonColor.value;
                          break;
                        case 2:
                          sf.slight.value = ut.buttonColor.value;
                          break;
                        case 3:
                          sf.modest.value = ut.buttonColor.value;
                          break;
                        case 4:
                          sf.generous.value = ut.buttonColor.value;
                          break;
                        case 5:
                          sf.exclusively.value = ut.buttonColor.value;
                          break;
                      }

                      sf.stats1.value = first.toString();
                      sf.stats2.value = second.toString();
                      sf.stats3.value = third.toString();
                      sf.autoAmp.value = autoAmpAv.toString();
                      sf.autoSpeak.value = autoSpeakAv.toString();
                      sf.parked.value = parkav;
                      sf.climb.value = climbAverage();
                      sf.harmony.value = harmonyav;
                      sv.selectMatch.value = 'Select a Match';
                      sf.strongSuit.value = strongest;
                    } else {
                      sv.teamMatches.value = [];
                      sv.selectMatch.value = 'N/A';
                      sf.stats1.value = 'N/A';
                      sf.stats2.value = 'N/A';
                      sf.stats3.value = 'N/A';
                      sf.autoAmp.value = 'N/A';
                      sf.autoSpeak.value = 'N/A';
                      sf.parked.value = 'N/A';
                      sf.harmony.value = 'N/A';
                      sf.climb.value = 'N/A';
                    }
                  },
                  items: sv.teamXList
                      .map((dynamic teamNumber) => DropdownMenuItem<int>(
                            value: teamNumber,
                            child: Text(
                              '${teamNumber.toString()} - ${sv.eventTeams[teamNumber]}',
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
                  iconStyleData:
                      const IconStyleData(iconEnabledColor: Colors.white),
                  dropdownStyleData: DropdownStyleData(
                    scrollbarTheme: const ScrollbarThemeData(
                        thumbColor: MaterialStatePropertyAll(Colors.grey)),
                    maxHeight: 400.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r)),
                  ),
                  buttonStyleData: ButtonStyleData(
                    width: 200.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                child: Obx(
                  () => SizedBox(
                    width: 160.w,
                    child: DropdownButton2(
                      underline: const SizedBox(),
                      isExpanded: true,
                      hint: Obx(
                        () => Text(
                          '${sv.selectMatch}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'NotoSans',
                            fontSize: 15,
                          ),
                        ),
                      ),
                      onChanged: (value) async {
                        bool startedInAuto = false;
                        sv.selectMatch.value = 'Match $value';
                        sf.clearView();

                        sv.matchSpecStats.value = true;
                        var startsBlue = sv.matchNumAndValue[value][0];
                        startsBlue == 'Blue'
                            ? sv.statsWantsBlue.value = true
                            : sv.statsWantsBlue.value = false;
                        startsBlue == 'Blue'
                            ? ut.buttonColor.value =
                                const Color.fromARGB(255, 0, 101, 179)
                            : ut.buttonColor.value =
                                const Color.fromARGB(255, 237, 52, 52);

                        if (sv.matchNumAndValue.isNotEmpty) {
                          String first = getMatchAverageNumbers(
                              made: 19, missed: 20, match: value);
                          String second = getMatchAverageNumbers(
                              made: 21, missed: 22, match: value);
                          String third = getMatchAverageNumbers(
                              made: 23, missed: 24, match: value);
                          String autoAmp = getMatchAverageNumbers(
                              made: 15, missed: 16, match: value);
                          String autoSpeak = getMatchAverageNumbers(
                              made: 17, missed: 18, match: value);
                          viewDiffScouterRespons(match: value);
                          for (int i = 2; i <= 5; i++) {
                            String position =
                                getMatchBool(column: i, match: value);

                            switch (i) {
                              case 2:
                                if (position != 'FALSE') {
                                  sf.viewZone1.value = ut.buttonColor.value;
                                  startedInAuto = true;
                                  break;
                                }
                              case 3:
                                if (position != 'FALSE') {
                                  sf.viewZone2.value = ut.buttonColor.value;
                                  startedInAuto = true;
                                  break;
                                }
                              case 4:
                                if (position != 'FALSE') {
                                  sf.viewZone3.value = ut.buttonColor.value;
                                  startedInAuto = true;
                                  break;
                                }
                              case 5:
                                if (position != 'FALSE') {
                                  sf.viewZone4.value = ut.buttonColor.value;
                                  startedInAuto = true;
                                  break;
                                }
                            }
                          }

                          sf.stats1.value = first.toString();
                          sf.stats2.value = second.toString();
                          sf.stats3.value = third.toString();
                          sf.autoAmp.value = autoAmp;
                          sf.autoSpeak.value = autoSpeak;
                          if (startedInAuto == true) {
                            for (int i = 6; i <= 13; i++) {
                              String whenSelected =
                                  getMatchBool(column: i, match: value);

                              switch (i) {
                                case 6:
                                  if (whenSelected != '0') {
                                    sf.viewNote1.value = whenSelected;
                                    sf.note1Color.value = ut.buttonColor.value;
                                    break;
                                  }
                                case 7:
                                  if (whenSelected != '0') {
                                    sf.viewNote2.value = whenSelected;
                                    sf.note2Color.value = ut.buttonColor.value;
                                    break;
                                  }
                                case 8:
                                  if (whenSelected != '0') {
                                    sf.viewNote3.value = whenSelected;
                                    sf.note3Color.value = ut.buttonColor.value;
                                    break;
                                  }
                                case 9:
                                  if (whenSelected != '0') {
                                    sf.viewNote4.value = whenSelected;
                                    sf.note4Color.value = ut.buttonColor.value;
                                    break;
                                  }
                                case 10:
                                  if (whenSelected != '0') {
                                    sf.viewNote5.value = whenSelected;
                                    sf.note5Color.value = ut.buttonColor.value;
                                    break;
                                  }

                                case 11:
                                  if (whenSelected != '0') {
                                    sf.viewNote6.value = whenSelected;
                                    sf.note6Color.value = ut.buttonColor.value;
                                    break;
                                  }
                                case 12:
                                  if (whenSelected != '0') {
                                    sf.viewNote7.value = whenSelected;
                                    sf.note7Color.value = ut.buttonColor.value;
                                    break;
                                  }
                                case 13:
                                  if (whenSelected != '0') {
                                    sf.viewNote8.value = whenSelected;
                                    sf.note8Color.value = ut.buttonColor.value;
                                    break;
                                  }
                              }
                            }
                          }

                          for (int i = 25; i <= 27; i++) {
                            String stagePos =
                                getMatchBool(column: i, match: value);
                            switch (i) {
                              case 25:
                                if (stagePos == 'TRUE') {
                                  sf.climb.value = 'Yes';
                                  sf.stage1.value = ut.buttonColor.value;
                                  break;
                                } else {
                                  sf.climb.value = "No";
                                }
                              case 26:
                                if (stagePos == 'TRUE') {
                                  sf.climb.value = 'Yes';
                                  sf.stage2.value = ut.buttonColor.value;
                                  break;
                                } else {
                                  sf.climb.value = "No";
                                }
                              case 27:
                                if (stagePos == 'TRUE') {
                                  sf.climb.value = 'Yes';
                                  sf.stage3.value = ut.buttonColor.value;
                                  break;
                                } else {
                                  sf.climb.value = "No";
                                }
                            }
                          }
                          for (int i = 33; i <= 37; i++) {
                            String others = sv.matchNumAndValue[value][i];
                            switch (i) {
                              case 33:
                                others == 'FALSE'
                                    ? sf.parked.value = 'No'
                                    : sf.parked.value = "Yes";
                              case 34:
                                others == 'FALSE'
                                    ? sf.harmony.value = 'No'
                                    : sf.harmony.value = "Yes";
                              case 35:
                                others == 'empty'
                                    ? sf.comments.value =
                                        'No comments available'
                                    : sf.comments.value = others;
                              case 36:
                                others == 'FALSE'
                                    ? sf.notesFromWhere.value = 'Floor'
                                    : sf.notesFromWhere.value = "Source";
                              case 37:
                                others == 'empty'
                                    ? sf.scouter.value = 'No Scouter?'
                                    : sf.scouter.value = others;
                            }
                          }
                          for (int i = 28; i <= 32; i++) {
                            String defense = sv.matchNumAndValue[value][i];
                            switch (i) {
                              case 28:
                                defense == 'TRUE'
                                    ? sf.none.value = ut.buttonColor.value
                                    : sf.none.value = Colors.transparent;
                              case 29:
                                defense == 'TRUE'
                                    ? sf.slight.value = ut.buttonColor.value
                                    : sf.slight.value = Colors.transparent;
                              case 30:
                                defense == 'TRUE'
                                    ? sf.modest.value = ut.buttonColor.value
                                    : sf.modest.value = Colors.transparent;
                              case 31:
                                defense == 'TRUE'
                                    ? sf.generous.value = ut.buttonColor.value
                                    : sf.generous.value = Colors.transparent;
                              case 32:
                                defense == 'TRUE'
                                    ? sf.exclusively.value =
                                        ut.buttonColor.value
                                    : sf.exclusively.value = Colors.transparent;
                            }
                          }
                        }
                      },
                      items: sv.teamMatches
                          .map(
                            (dynamic matchNum) => DropdownMenuItem<dynamic>(
                              value: matchNum,
                              child: Text(
                                'Match ${matchNum.toString()}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'NotoSans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              ),
                            ),
                          )
                          .toList(),
                      alignment: Alignment.center,
                      iconStyleData:
                          const IconStyleData(iconEnabledColor: Colors.white),
                      dropdownStyleData: DropdownStyleData(
                        scrollbarTheme: const ScrollbarThemeData(
                            thumbColor: MaterialStatePropertyAll(Colors.grey)),
                        maxHeight: 400.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r)),
                      ),
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(15.r)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: !sv.matchSpecStats.value,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Center(
                    child: Obx(
                      () => Text(
                        'Strong Suit: ${sf.strongSuit}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'NotoSans',
                            fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            rw.line(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: const Center(
                child: Text(
                  'Auto',
                  style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
            ),
            Obx(
              () => sv.statsWantsBlue.value
                  ? sf.statsBlueAuto()
                  : sf.statsRedAuto(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  showAverage(value: sf.autoAmp, title: 'Amp'),
                  showAverage(value: sf.autoSpeak, title: 'Speaker')
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: rw.line(),
            ),
            const Center(
              child: Text(
                'Teleop',
                style: TextStyle(
                    fontFamily: 'NotoSans', fontSize: 25, color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                showAverage(value: sf.stats1, title: 'Amp'),
                showAverage(value: sf.stats2, title: 'Speaker'),
                showAverage(value: sf.stats3, title: 'Trap')
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 15.h, bottom: 3.h),
                child: rw.line()),
            const Center(
              child: Text(
                'Endgame',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'NotoSans', fontSize: 25),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
              child: Obx(
                () => sv.statsWantsBlue.value
                    ? sf.statsBlueStage()
                    : sf.statsRedStage(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                          color: ut.buttonColor.value,
                          borderRadius: BorderRadiusDirectional.circular(15.r)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        child: Column(
                          children: [
                            const Text(
                              "Parked",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'NotoSans',
                                  fontSize: 27),
                            ),
                            Text(
                              sf.parked.value,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'NotoSans',
                                  fontSize: 25),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: !sv.matchSpecStats.value,
                    child: Center(
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                              color: ut.buttonColor.value,
                              borderRadius:
                                  BorderRadiusDirectional.circular(15.r)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.h),
                            child: Column(
                              children: [
                                const Text(
                                  "Climb",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'NotoSans',
                                      fontSize: 27),
                                ),
                                Text(
                                  sf.climb.value,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'NotoSans',
                                      fontSize: 25),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                          color: ut.buttonColor.value,
                          borderRadius: BorderRadiusDirectional.circular(15.r)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        child: Column(
                          children: [
                            const Text(
                              "Harmony",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'NotoSans',
                                  fontSize: 27),
                            ),
                            Text(
                              sf.harmony.value,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'NotoSans',
                                  fontSize: 25),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
              child: const Center(
                  child: Text(
                "Defense",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontSize: 25, fontFamily: 'NotoSans'),
              )),
            ),
            sf.defenseRow(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Center(
                child: Obx(
                  () => Text(
                    'Mainly got Notes From: ${sf.notesFromWhere}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'NotoSans'),
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: !sv.matchSpecStats.value,
                replacement: Column(
                  children: [
                    const Center(
                      child: Text(
                        "Comments:",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'NotoSans',
                            fontSize: 25),
                      ),
                    ),
                    Center(
                      child: Obx(
                        () => Text(
                          sf.comments.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'NotoSans',
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Center(
                    child: Column(
                      children: [
                        Obx(
                          (() => DropdownButton2(
                                hint: Text(
                                  sf.dropdownComments.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'NotoSans',
                                    fontSize: 19,
                                  ),
                                ),
                                onChanged: (value) {
                                  sf.comments.value =
                                      sv.allComments[value][0].toString();
                                  sf.dropdownComments.value = 'Match: $value';
                                  sf.scouter.value = sv.allComments[value][1];
                                },
                                iconStyleData: const IconStyleData(
                                    iconEnabledColor: Colors.white),
                                items: sv.commentCount
                                    .map(
                                      (dynamic match) =>
                                          DropdownMenuItem<dynamic>(
                                        value: match,
                                        child: Text(
                                          'Match: $match',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'NotoSans',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                dropdownStyleData: DropdownStyleData(
                                  scrollbarTheme: const ScrollbarThemeData(
                                      thumbColor: MaterialStatePropertyAll(
                                          Colors.grey)),
                                  maxHeight: 400.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(15.r)),
                                ),
                                buttonStyleData: ButtonStyleData(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius:
                                          BorderRadius.circular(15.r)),
                                ),
                                underline: const SizedBox(),
                              )),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Obx(
                          () => Text(
                            sf.comments.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'NotoSans',
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: !sv.matchCommDropAva.value,
                replacement: Center(
                  child: DropdownButton2(
                    hint: Text(
                      sf.scoutersDropdown.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'NotoSans',
                        fontSize: 19,
                      ),
                    ),
                    onChanged: (value) {
                      bool startedInAuto = false;
                      List newList = sv.scoutersMap[value];
                      sf.scoutersDropdown.value = value.toString();
                      sf.clearView();

                      sv.matchSpecStats.value = true;
                      var startsBlue = newList[0];
                      startsBlue == 'Blue'
                          ? sv.statsWantsBlue.value = true
                          : sv.statsWantsBlue.value = false;
                      startsBlue == 'Blue'
                          ? ut.buttonColor.value =
                              const Color.fromARGB(255, 0, 101, 179)
                          : ut.buttonColor.value =
                              const Color.fromARGB(255, 237, 52, 52);

                      if (sv.scoutersMap.isNotEmpty) {
                        String first = getMatchAverageNumbers(
                            made: 19,
                            missed: 20,
                            match: value,
                            newScouter: value);
                        String second = getMatchAverageNumbers(
                            made: 21,
                            missed: 22,
                            match: value,
                            newScouter: value);
                        String third = getMatchAverageNumbers(
                            made: 23,
                            missed: 24,
                            match: value,
                            newScouter: value);
                        String autoAmp = getMatchAverageNumbers(
                            made: 15,
                            missed: 16,
                            match: value,
                            newScouter: value);
                        String autoSpeak = getMatchAverageNumbers(
                            made: 17,
                            missed: 18,
                            match: value,
                            newScouter: value);
                        for (int i = 2; i <= 5; i++) {
                          String position = getMatchBool(
                              column: i, match: value, newScouter: value);

                          switch (i) {
                            case 2:
                              if (position != 'FALSE') {
                                sf.viewZone1.value = ut.buttonColor.value;
                                startedInAuto = true;
                                break;
                              }
                            case 3:
                              if (position != 'FALSE') {
                                sf.viewZone2.value = ut.buttonColor.value;
                                startedInAuto = true;
                                break;
                              }
                            case 4:
                              if (position != 'FALSE') {
                                sf.viewZone3.value = ut.buttonColor.value;
                                startedInAuto = true;
                                break;
                              }
                            case 5:
                              if (position != 'FALSE') {
                                sf.viewZone4.value = ut.buttonColor.value;
                                startedInAuto = true;
                                break;
                              }
                          }
                        }

                        sf.stats1.value = first.toString();
                        sf.stats2.value = second.toString();
                        sf.stats3.value = third.toString();
                        sf.autoAmp.value = autoAmp;
                        sf.autoSpeak.value = autoSpeak;
                        if (startedInAuto == true) {
                          for (int i = 6; i <= 13; i++) {
                            String whenSelected = getMatchBool(
                                column: i, match: value, newScouter: value);

                            switch (i) {
                              case 6:
                                if (whenSelected != '0') {
                                  sf.viewNote1.value = whenSelected;
                                  sf.note1Color.value = ut.buttonColor.value;
                                  break;
                                }
                              case 7:
                                if (whenSelected != '0') {
                                  sf.viewNote2.value = whenSelected;
                                  sf.note2Color.value = ut.buttonColor.value;
                                  break;
                                }
                              case 8:
                                if (whenSelected != '0') {
                                  sf.viewNote3.value = whenSelected;
                                  sf.note3Color.value = ut.buttonColor.value;
                                  break;
                                }
                              case 9:
                                if (whenSelected != '0') {
                                  sf.viewNote4.value = whenSelected;
                                  sf.note4Color.value = ut.buttonColor.value;
                                  break;
                                }
                              case 10:
                                if (whenSelected != '0') {
                                  sf.viewNote5.value = whenSelected;
                                  sf.note5Color.value = ut.buttonColor.value;
                                  break;
                                }

                              case 11:
                                if (whenSelected != '0') {
                                  sf.viewNote6.value = whenSelected;
                                  sf.note6Color.value = ut.buttonColor.value;
                                  break;
                                }
                              case 12:
                                if (whenSelected != '0') {
                                  sf.viewNote7.value = whenSelected;
                                  sf.note7Color.value = ut.buttonColor.value;
                                  break;
                                }
                              case 13:
                                if (whenSelected != '0') {
                                  sf.viewNote8.value = whenSelected;
                                  sf.note8Color.value = ut.buttonColor.value;
                                  break;
                                }
                            }
                          }
                        }

                        for (int i = 25; i <= 27; i++) {
                          String stagePos = getMatchBool(
                              column: i, match: value, newScouter: value);
                          switch (i) {
                            case 25:
                              if (stagePos == 'TRUE') {
                                sf.climb.value = 'Yes';
                                sf.stage1.value = ut.buttonColor.value;
                                break;
                              } else {
                                sf.climb.value = "No";
                              }
                            case 26:
                              if (stagePos == 'TRUE') {
                                sf.climb.value = 'Yes';
                                sf.stage2.value = ut.buttonColor.value;
                                break;
                              } else {
                                sf.climb.value = "No";
                              }
                            case 27:
                              if (stagePos == 'TRUE') {
                                sf.climb.value = 'Yes';
                                sf.stage3.value = ut.buttonColor.value;
                                break;
                              } else {
                                sf.climb.value = "No";
                              }
                          }
                        }
                        for (int i = 33; i <= 37; i++) {
                          String others = newList[i];
                          switch (i) {
                            case 33:
                              others == 'FALSE'
                                  ? sf.parked.value = 'No'
                                  : sf.parked.value = "Yes";
                            case 34:
                              others == 'FALSE'
                                  ? sf.harmony.value = 'No'
                                  : sf.harmony.value = "Yes";
                            case 35:
                              others == 'empty'
                                  ? sf.comments.value = 'No comments available'
                                  : sf.comments.value = others;
                            case 36:
                              others == 'FALSE'
                                  ? sf.notesFromWhere.value = 'Floor'
                                  : sf.notesFromWhere.value = "Source";
                            case 37:
                              others == 'empty'
                                  ? sf.scouter.value = 'No Scouter?'
                                  : sf.scouter.value = others;
                          }
                        }
                        for (int i = 28; i <= 32; i++) {
                          String defense = newList[i];
                          switch (i) {
                            case 28:
                              defense == 'TRUE'
                                  ? sf.none.value = ut.buttonColor.value
                                  : sf.none.value = Colors.transparent;
                            case 29:
                              defense == 'TRUE'
                                  ? sf.slight.value = ut.buttonColor.value
                                  : sf.slight.value = Colors.transparent;
                            case 30:
                              defense == 'TRUE'
                                  ? sf.modest.value = ut.buttonColor.value
                                  : sf.modest.value = Colors.transparent;
                            case 31:
                              defense == 'TRUE'
                                  ? sf.generous.value = ut.buttonColor.value
                                  : sf.generous.value = Colors.transparent;
                            case 32:
                              defense == 'TRUE'
                                  ? sf.exclusively.value = ut.buttonColor.value
                                  : sf.exclusively.value = Colors.transparent;
                          }
                        }
                      }
                    },
                    iconStyleData:
                        const IconStyleData(iconEnabledColor: Colors.white),
                    items: sv.matchScouters
                        .map(
                          (dynamic scouter) => DropdownMenuItem<dynamic>(
                            value: scouter,
                            child: Text(
                              '$scouter',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'NotoSans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        )
                        .toList(),
                    dropdownStyleData: DropdownStyleData(
                      scrollbarTheme: const ScrollbarThemeData(
                          thumbColor: MaterialStatePropertyAll(Colors.grey)),
                      maxHeight: 400.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r)),
                    ),
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(15.r)),
                    ),
                    underline: const SizedBox(),
                  ),
                ),
                child: Center(
                  child: Obx(
                    () => Text(
                      'Scouter: ${sf.scouter}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'NotoSans',
                          fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: rw.bnb(),
    );
  }
}
/*
SizedBox(
            width: 200.w,
            height: 450.h,
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.white,
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    dashArray: <int>[5, 5],
                    barWidth: 4,
                    curveSmoothness: 0.3,
                    isCurved: true,
                    spots: const [
                      FlSpot(1, 10),
                      FlSpot(2, 4),
                      FlSpot(3, 7),
                      FlSpot(4, 8),
                      FlSpot(5, 8),
                    ],
                  ),
                ],
                borderData: FlBorderData(
                    border: Border.all(color: ut.tt.value, width: 3)),
                minX: 1,
                maxX: 10,
                minY: 0,
                maxY: 10,
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40.h,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 40.h,
                    axisNameWidget: rw.textForGraph(name: 'Match'),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25.h,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: rw.textForGraph(name: 'Speaker'),
                    axisNameSize: 35.w,
                    sideTitles:
                        SideTitles(showTitles: true, reservedSize: 24.h),
                  ),
                ),
              ),
            ),
          ),
      */

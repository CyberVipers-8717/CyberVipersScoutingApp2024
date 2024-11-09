import 'reuseable_widgets.dart';
import 'user_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

ReuseWid rw = Get.find();
UserTheme ut = Get.find();

class SheetValues extends GetxController {
  RxInt matchNum = 0.obs;
  RxString alliance = ''.obs;
  RxInt teamNum = 0.obs;

  // ignore: prefer_typing_uninitialized_variables
  var selectedValue;

  RxList matches = [].obs;
  RxList teamMatches = [].obs;
  RxBool selectedAMatch = false.obs;

  RxString matchHint = 'Select a Match'.obs;

  RxBool posAmp = false.obs;
  RxBool posCenter = false.obs;
  RxBool posBetween = false.obs;
  RxBool posSource = false.obs;

  RxInt gloablNote = 0.obs;
  RxInt note1 = 0.obs; //note closest to the amp
  RxInt note2 = 0.obs;
  RxInt note3 = 0.obs; //note farthest to the amp

  RxInt note4 = 0.obs; //note closest to the amp on the bottom
  RxInt note5 = 0.obs;
  RxInt note6 = 0.obs;
  RxInt note7 = 0.obs;
  RxInt note8 = 0.obs; //note farthest to the amp bottom

  RxBool leave = false.obs;
  Rx<MaterialStateProperty<Icon>> leaveIcon =
      const MaterialStatePropertyAll(Icon(Icons.close)).obs;

  RxInt autoAmp = 0.obs;
  RxInt autoAmpMissed = 0.obs;
  RxInt teleopAmp = 0.obs;
  RxInt ampMissed = 0.obs;

  RxInt autoSpeaker = 0.obs;
  RxInt autoSpeakerMissed = 0.obs;
  RxInt teleopSpeaker = 0.obs;
  RxInt speakerMissed = 0.obs;

  RxList teamOnlyData = [].obs;

  RxInt trap = 0.obs;
  RxInt trapMissed = 0.obs;

  RxBool dNone = true.obs;
  RxBool dSlight = false.obs;
  RxBool dModest = false.obs;
  RxBool dGenerous = false.obs;
  RxBool dExclusively = false.obs;

  RxBool leftStage = false.obs;
  RxBool centerStage = false.obs;
  RxBool rightStage = false.obs;

  RxBool park = false.obs;
  RxBool harmony = false.obs;

  RxMap allianceMatches = {}.obs;
  RxBool isOnBlueAlliance = false.obs;
  RxBool selectedAnEvent = false.obs;

  final scoutersTeam = TextEditingController();
  final scoutName = TextEditingController();
  final comments = TextEditingController();

  RxMap eventTeams = {}.obs;

  RxString teamListHint = 'Select A Team To View'.obs;

  RxString eventKey = ''.obs;
  RxList teamXList = [].obs;

  RxInt selectedTeamNumber = 0.obs;
  RxList selectedTeamValue = [].obs;

  RxBool isDistrict = false.obs;

  RxMap regionalEventsMap = {}.obs;
  RxList regionalEventNames = [].obs;

  RxMap districtEventsMap = {}.obs;
  RxList districtEventNames = [].obs;

  RxMap allComments = {}.obs;
  RxList commentCount = [].obs;

  RxList viewAllScoutComment = [].obs;
  RxBool matchCommDropAva = false.obs;
  RxList matchScouters = [].obs;
  RxMap scoutersMap = {}.obs;

  RxMap worldsFieldsMap = {
    'Archimedes': 'arc',
    'Newton': 'new',
    'Curie': 'cur',
    'Daly': 'dal',
    'Galileo': 'gal',
    'Hopper': 'hop',
    'Johnson': 'joh',
    'Milstein': 'mil',
  }.obs;
  RxList worldsFieldsNames = [].obs;

  RxBool matchSpecStats = false.obs;

  RxString eventListHint = 'Select a Field'.obs;

  RxList events = [].obs;

  RxMap matchNumAndValue = {}.obs;
  RxString selectMatch = 'Select a Match'.obs;

  RxBool statsWantsBlue = true.obs;
  RxBool alreadyInStats = false.obs;

  RxBool notesFromSource = false.obs;

  Rx<MaterialStateProperty<Icon?>> switchIcon =
      const MaterialStatePropertyAll(Icon(Icons.close)).obs;

  final MaterialStateProperty<Icon> switchIcon1 =
      const MaterialStatePropertyAll(Icon(Icons.close));
  final MaterialStateProperty<Icon> switchIcon2 =
      const MaterialStatePropertyAll(Icon(Icons.check));
  RxBool wantsTeamOnlyStats = false.obs;

  final pref = GetStorage();

  valueModifier({required RxInt value, required String title}) {
    return InkWell(
      splashColor: const Color.fromARGB(80, 255, 255, 255),
      borderRadius: BorderRadius.circular(12.r),
      onTap: () {
        value++;
        if (trap > 3) trap.value = 3;
      },
      onLongPress: () {
        value--;
        if (value < 0) {
          value.value = 0;
        }
      },
      child: Ink(
        width: 120.w,
        height: 110.h,
        decoration: BoxDecoration(
            color: ut.buttonColor.value,
            borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'NotoSans',
                fontSize: 28,
              ),
            ),
            Obx(
              () => Text(
                '$value',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'NotoSans',
                  fontSize: 35,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  finished() {
    matchNum.value = 1;
    teamNum.value = 1;

    posAmp.value = false;
    posCenter.value = false;
    posBetween.value = false;
    posSource.value = false;

    gloablNote.value = 0;

    note1.value = 0; //note closest to the amp
    note2.value = 0;
    note3.value = 0; //note farthest to the amp

    note4.value = 0; //note closest to the amp on the bottom
    note5.value = 0;
    note6.value = 0;
    note7.value = 0;
    note8.value = 0; //note farthest to the amp bottom

    leave.value = false;
    leaveIcon.value = const MaterialStatePropertyAll(Icon(Icons.close));

    autoAmp.value = 0;
    autoAmpMissed.value = 0;
    teleopAmp.value = 0;
    ampMissed.value = 0;

    autoSpeaker.value = 0;
    autoSpeakerMissed.value = 0;
    teleopSpeaker.value = 0;
    speakerMissed.value = 0;

    trap.value = 0;
    trapMissed.value = 0;

    leftStage.value = false;
    centerStage.value = false;
    rightStage.value = false;

    dNone.value = true;
    dSlight.value = false;
    dModest.value = false;
    dGenerous.value = false;
    dExclusively.value = false;

    park.value = false;
    harmony.value = false;
    commentCount.value = [];

    comments.clear();

    notesFromSource.value = false;
  }
}

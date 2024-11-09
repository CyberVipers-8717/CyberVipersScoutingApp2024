import '../controllers/field_with_buttons.dart';
import '../controllers/google_sheets_api.dart';
import '../controllers/reuseable_widgets.dart';
import '../controllers/sheet_values.dart';
import '../controllers/user.dart';
import '../controllers/user_theme.dart';
import '../scouting_pages/engame_defense.dart';
import '../scouting_pages/scouting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FinalPage extends StatelessWidget {
  const FinalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    UserTheme ut = Get.find();
    ReuseWid rw = Get.find();
    SheetValues sv = Get.find();
    TouchField tf = Get.find();
    EndgameDefense eg = Get.find();

    return Scaffold(
      appBar: rw.ab(title: 'Comments'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          rw.line(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: rw.notesFromWhere(),
          ),
          SizedBox(
            width: 320.w,
            child: TextField(
              autocorrect: true,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              maxLines: null,
              enabled: true,
              controller: sv.comments,
              textAlign: TextAlign.center,
              cursorColor: Colors.white,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'NotoSans', fontSize: 20),
              decoration: InputDecoration(
                label: const Center(
                  child: Text(
                    'Comments',
                    style: TextStyle(
                        color: Color.fromARGB(85, 255, 255, 255),
                        fontFamily: 'NotoSans',
                        fontSize: 20),
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: const TextStyle(color: Colors.white),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(color: Colors.white, width: 2.w)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(color: Colors.white, width: 2.w)),
              ),
            ),
          ),
          if (!isKeyboard)
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    final submitData = {
                      UserFields.teamNum: sv.teamNum.value,
                      UserFields.alliance: sv.alliance.value,
                      UserFields.matchNum: sv.matchNum.value,
                      UserFields.posAmp: sv.posAmp.value,
                      UserFields.posCenter: sv.posCenter.value,
                      UserFields.posBetween: sv.posBetween.value,
                      UserFields.posSource: sv.posSource.value,
                      UserFields.note1: sv.note1.value,
                      UserFields.note2: sv.note2.value,
                      UserFields.note3: sv.note3.value,
                      UserFields.note4: sv.note4.value,
                      UserFields.note5: sv.note5.value,
                      UserFields.note6: sv.note6.value,
                      UserFields.note7: sv.note7.value,
                      UserFields.note8: sv.note8.value,
                      UserFields.leave: sv.leave.value,
                      UserFields.autoAmp: sv.autoAmp.value,
                      UserFields.autoAmpMissed: sv.autoAmpMissed.value,
                      UserFields.autoSpeker: sv.autoSpeaker.value,
                      UserFields.autoSpeakerMissed: sv.autoSpeakerMissed.value,
                      UserFields.teleopAmp: sv.teleopAmp.value,
                      UserFields.teleopAmpMissed: sv.ampMissed.value,
                      UserFields.teleopSpeaker: sv.teleopSpeaker.value,
                      UserFields.teleopSpeakerMissed: sv.speakerMissed.value,
                      UserFields.trap: sv.trap.value,
                      UserFields.trapMissed: sv.trapMissed.value,
                      UserFields.leftStage: sv.leftStage.value,
                      UserFields.centerStage: sv.centerStage.value,
                      UserFields.rightStage: sv.rightStage.value,
                      UserFields.dNone: sv.dNone.value,
                      UserFields.dSlight: sv.dSlight.value,
                      UserFields.dModest: sv.dModest.value,
                      UserFields.dGenerous: sv.dGenerous.value,
                      UserFields.dExclusively: sv.dExclusively.value,
                      UserFields.park: sv.park.value,
                      UserFields.harmony: sv.harmony.value,
                      UserFields.comments: sv.comments.text,
                      UserFields.notesFromWhere: sv.notesFromSource.value,
                      UserFields.scoutersName: sv.scoutName.text,
                      UserFields.scoutersTeam: sv.scoutersTeam.text,
                    };
                    await GoogleSheetsApi.sendData([submitData]);
                    sv.finished();
                    tf.finished();
                    eg.finished();
                    Get.offAll(() => const ScoutingPage());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 18.h),
                    child: Container(
                      width: 280.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: ut.buttonColor.value,
                        borderRadius: BorderRadius.circular(35.r),
                      ),
                      child: const Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'NotoSans',
                              fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

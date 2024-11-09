import '../controllers/reuseable_widgets.dart';
import '../controllers/sheet_values.dart';
import '../controllers/user_theme.dart';
import '../scouting_pages/endgame.dart';
import '../scouting_pages/engame_defense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TeleopScreen extends StatelessWidget {
  const TeleopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ReuseWid rw = Get.find();
    SheetValues sv = Get.find();
    UserTheme ut = Get.find();
    EndgameDefense ed = Get.put(EndgameDefense());
    return Scaffold(
      appBar: rw.ab(title: 'Teleop'),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            rw.line(),
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: rw.teaminfo(),
            ),
            SizedBox(
              height: 120.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                sv.valueModifier(value: sv.teleopAmp, title: 'Amp'),
                sv.valueModifier(value: sv.ampMissed, title: 'Missed')
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  sv.valueModifier(value: sv.teleopSpeaker, title: 'Speaker'),
                  sv.valueModifier(value: sv.speakerMissed, title: 'Missed')
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  sv.valueModifier(value: sv.trap, title: 'Trap'),
                  sv.valueModifier(value: sv.trapMissed, title: 'Missed')
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 18.h),
                  child: GestureDetector(
                    onTap: () {
                      if (sv.dNone.isTrue) {
                        ed.dNoneColor.value = ut.buttonColor.value;
                      }
                      Get.to(() => const Endgame());
                    },
                    child: Container(
                      width: 250.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: ut.buttonColor.value,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '"Endgame"',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'NotoSans',
                                fontSize: 25),
                          ),
                          SizedBox(
                            width: 7.w,
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

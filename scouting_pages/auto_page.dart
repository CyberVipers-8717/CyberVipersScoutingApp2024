import '../controllers/field_with_buttons.dart';
import '../controllers/reuseable_widgets.dart';
import '../controllers/sheet_values.dart';
import '../controllers/user_theme.dart';
import '../scouting_pages/teleop_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AutoStart extends StatelessWidget {
  const AutoStart({super.key});

  @override
  Widget build(BuildContext context) {
    UserTheme ut = Get.find();
    ReuseWid rw = Get.find();
    SheetValues sv = Get.find();
    TouchField tf = Get.put(TouchField());

    return Scaffold(
      appBar: rw.ab(title: 'Auto'),
      body: Column(
        children: [
          rw.line(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: rw.teaminfo(),
          ),
          sv.alliance.value == 'Blue' ? tf.blueSide() : tf.redSide(),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                sv.valueModifier(value: sv.autoAmp, title: 'Amp'),
                sv.valueModifier(value: sv.autoAmpMissed, title: 'Missed'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                sv.valueModifier(value: sv.autoSpeaker, title: 'Speaker'),
                sv.valueModifier(value: sv.autoSpeakerMissed, title: 'Missed')
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: const Text(
                      'Leave',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NotoSans',
                          fontSize: 25),
                    ),
                  ),
                  Obx(
                    () => Switch.adaptive(
                      activeTrackColor: ut.buttonColor.value,
                      thumbIcon: sv.leaveIcon.value,
                      trackOutlineColor:
                          const MaterialStatePropertyAll(Colors.white),
                      value: sv.leave.value,
                      onChanged: (value) {
                        if (sv.leave.value == false) {
                          sv.leave.value = true;
                          sv.leaveIcon.value = sv.switchIcon2;
                        } else {
                          sv.leave.value = false;
                          sv.leaveIcon.value = sv.switchIcon1;
                        }
                      },
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const TeleopScreen());
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: ut.buttonColor.value,
                      borderRadius: BorderRadius.circular(18.r)),
                  width: 160.w,
                  height: 50.h,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Teleop',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'NotoSans',
                            fontSize: 25),
                      ),
                      SizedBox(
                        width: 7.w,
                      ),
                      Icon(
                        size: 30.w,
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

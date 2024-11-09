import '../controllers/field_with_buttons.dart';
import '../controllers/reuseable_widgets.dart';
import '../controllers/sheet_values.dart';
import '../controllers/user_theme.dart';
import '../scouting_pages/engame_defense.dart';
import '../scouting_pages/final_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Endgame extends StatelessWidget {
  const Endgame({super.key});

  @override
  Widget build(BuildContext context) {
    ReuseWid rw = Get.find();
    SheetValues sv = Get.find();
    TouchField tf = Get.find();
    UserTheme ut = Get.find();
    EndgameDefense ed = Get.put(EndgameDefense());

    return Scaffold(
      appBar: rw.ab(title: '"Endgame"'),
      body: Column(
        children: [
          rw.line(),
          Padding(
            padding: EdgeInsets.only(top: 5.h, bottom: 20.h),
            child: rw.teaminfo(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashFactory: InkSplash.splashFactory,
                  splashColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(18.r),
                  onTap: () {
                    if (sv.harmony.isTrue ||
                        sv.leftStage.isTrue ||
                        sv.centerStage.isTrue ||
                        sv.rightStage.isTrue) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.grey[800],
                          showCloseIcon: true,
                          content: const Text(
                            'Cant Select Parked',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'NotoSans',
                                fontSize: 25),
                          ),
                        ),
                      );
                    } else {
                      if (sv.park.isFalse) {
                        sv.park.value = true;
                        ed.parkedColor.value = ut.buttonColor.value;
                      } else {
                        sv.park.value = false;
                        ed.parkedColor.value = Colors.transparent;
                      }
                    }
                  },
                  child: Obx(
                    () => Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                              color: ut.buttonColor.value, width: 4.w),
                          color: ed.parkedColor.value),
                      height: 60.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: const Center(
                          child: Text(
                            'Parked',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'NotoSans'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25.w,
                ),
                InkWell(
                  splashFactory: InkSplash.splashFactory,
                  splashColor: Colors.grey[300],
                  borderRadius: BorderRadius.circular(18.r),
                  onTap: () {
                    sv.park.value = false;
                    ed.parkedColor.value = Colors.transparent;
                    if (sv.harmony.isFalse) {
                      sv.harmony.value = true;
                      ed.harmonyColor.value = ut.buttonColor.value;
                    } else {
                      sv.harmony.value = false;
                      ed.harmonyColor.value = Colors.transparent;
                    }
                  },
                  child: Obx(
                    () => Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                              color: ut.buttonColor.value, width: 4.w),
                          color: ed.harmonyColor.value),
                      height: 60.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: const Center(
                          child: Text(
                            'Harmony',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'NotoSans'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: const Text(
              'Defense',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'NotoSans', fontSize: 35),
            ),
          ),
          ed.defenseRow(),
          Padding(
              padding: EdgeInsets.only(top: 40.h, bottom: 25.h),
              child:
                  sv.alliance.value == 'Blue' ? tf.blueStage() : tf.redStage()),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: GestureDetector(
                  onTap: () => Get.to(() => const FinalPage()),
                  child: Container(
                    width: 250.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: ut.buttonColor.value,
                      borderRadius: BorderRadius.circular(35.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Comments',
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
    );
  }
}

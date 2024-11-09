import 'controllers/reuseable_widgets.dart';
import 'controllers/sheet_values.dart';
import 'controllers/user_theme.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ReuseWid rw = Get.put(ReuseWid());
    SheetValues sv = Get.find();
    UserTheme ut = Get.find();

    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Welcome',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'NotoSans',
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          rw.nameField(),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: SizedBox(
                width: 110.w,
                child: Obx(
                  () => TextField(
                    maxLength: 4,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    controller: sv.scoutersTeam,
                    textAlign: TextAlign.center,
                    enabled: true,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'NotoSans',
                        fontSize: 20),
                    decoration: InputDecoration(
                      counterText: '',
                      label: Center(
                        child: Text(
                          'Team #',
                          style: TextStyle(
                              color: ut.ts,
                              fontFamily: 'NotoSans',
                              fontSize: 20),
                        ),
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide:
                              BorderSide(color: ut.tfc.value, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide:
                              BorderSide(color: ut.tfc.value, width: 2)),
                    ),
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Center(
              child: rw.eventDropDown(),
            ),
          ),
          rw.statsType(),
          const Expanded(child: SizedBox()),
          if (!isKeyboard)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: GestureDetector(
                  onTap: () {
                    if (sv.scoutName.text.isEmpty ||
                        sv.scoutersTeam.text.isEmpty ||
                        sv.selectedAnEvent.isFalse) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          showCloseIcon: true,
                          backgroundColor: Colors.grey[800],
                          content: const Text(
                            'Fill in All Values',
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    } else {
                      sv.pref.write('scouters name', sv.scoutName.text);
                      sv.pref.write('scouters team', sv.scoutersTeam.text);
                      sv.pref.write('event key', sv.eventKey.value);
                      sv.pref
                          .write('selected event name', sv.eventListHint.value);
                      sv.pref
                          .write('selected event?', sv.selectedAnEvent.value);
                      sv.pref
                          .write('team only data', sv.wantsTeamOnlyStats.value);

                      sv.pref.write('booted', true);
                      Get.off(() => const HomePage());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 13.w),
                      child: const Text(
                        'LETS GET SCOUTING',
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'NotoSans',
                            color: Colors.white),
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

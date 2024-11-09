import 'controllers/reuseable_widgets.dart';
import 'controllers/sheet_values.dart';
import 'controllers/user_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ReuseWid rw = Get.put(ReuseWid());
    UserTheme ut = Get.put(UserTheme());
    SheetValues sv = Get.find();
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: rw.ab(title: 'Home Page'),
      drawer: rw.d(),
      body: Column(
        children: [
          rw.line(),
          if (!isKeyboard)
            Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: Image(
                height: 530.h,
                image: const AssetImage('lib/assets/worlds_sponsor_image.png'),
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  rw.nameField(),
                  SizedBox(
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: rw.bnb(),
    );
  }
}

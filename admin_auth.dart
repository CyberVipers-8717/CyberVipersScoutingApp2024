import 'admin_hub.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'controllers/reuseable_widgets.dart';
import 'controllers/user_theme.dart';

class AdminAuth extends StatelessWidget {
  const AdminAuth({super.key});

  @override
  Widget build(BuildContext context) {
    ReuseWid rw = Get.find();
    UserTheme ut = Get.find();
    return Scaffold(
        appBar: rw.ab(title: 'Admin Authentication'),
        body: Column(
          children: [
            rw.line(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      label: Center(
                          child: Text(
                        'Password',
                        style: TextStyle(
                            color: ut.ts, fontFamily: 'NotoSans', fontSize: 20),
                      )),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: BorderSide(color: Colors.white, width: 2.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        borderSide: BorderSide(color: Colors.white, width: 2.w),
                      ),
                    ),
                    cursorColor: Colors.white,
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'NotoSans'),
                    onSubmitted: (value) {
                      if (value != '8717') {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.red,
                            child: SizedBox(
                              width: 100.w,
                              height: 100.h,
                              child: const Center(
                                child: Text(
                                  'TRY AGAIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SenorSaturno',
                                      fontSize: 40),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        Get.offAll(() => const AdminHub());
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

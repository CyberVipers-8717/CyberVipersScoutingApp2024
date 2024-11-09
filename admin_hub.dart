import 'controllers/reuseable_widgets.dart';
import 'controllers/sheet_values.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminHub extends StatelessWidget {
  const AdminHub({super.key});
  @override
  Widget build(BuildContext context) {
    ReuseWid rw = Get.find();
    SheetValues sv = Get.find();
    return Scaffold(
      appBar: rw.ab(title: 'Admin Hub'),
      body: Column(
        children: [
          rw.line(),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: const Text(
                '0/6 in Lobby',
                style: TextStyle(
                    color: Colors.white, fontSize: 45, fontFamily: 'NotoSans'),
              ),
            ),
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Match',
                style: TextStyle(
                    color: Colors.white, fontSize: 45, fontFamily: 'NotoSans'),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: Colors.grey[350],
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () {
                      sv.matchNum--;
                      if (sv.matchNum.value < 1) {
                        sv.matchNum.value = 1;
                      }
                    },
                    child: Ink(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Icon(
                        Icons.subdirectory_arrow_left_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 33.w,
                    height: 0,
                  ),
                  Obx(
                    () => Text(
                      sv.matchNum.value.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'NotoSans',
                          fontSize: 70),
                    ),
                  ),
                  SizedBox(
                    width: 33.w,
                    height: 0,
                  ),
                  InkWell(
                    splashColor: Colors.grey[350],
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () => sv.matchNum++,
                    child: Ink(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Icon(
                        Icons.subdirectory_arrow_right_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              width: 200.w,
              height: 100.h,
              decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(18.r)),
              child: const Center(
                child: Text(
                  'GO!',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'NotoSans',
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => Get.off(() => const HomePage()),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Container(
                    width: 300.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                        color: Colors.red[700],
                        borderRadius: BorderRadius.circular(35.r)),
                    child: const Center(
                      child: Text(
                        'Close Lobby',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NotoSans',
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

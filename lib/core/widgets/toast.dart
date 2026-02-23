import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notely/core/utils/colors.dart';

void customToast(String msg,{Color? bgColor,Color? textColor}) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: bgColor?? AppColors.primaryBg,
    textColor:  textColor?? AppColors.black,
  );
}

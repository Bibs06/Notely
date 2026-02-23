import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notely/core/utils/colors.dart';

class CustomBtn extends StatelessWidget {
  final Function()? onTap;
  final String btnText;
  final double? borderRadius;
  final Color? bgColor;
  final double? textSize;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? padX;
  final double? padY;
  final bool? isLoading;
  final Color? borderColor;

  const CustomBtn({
    super.key,
    this.onTap,
    this.width,
    this.height,
    this.textSize,
    this.borderColor,
    this.padX,
    this.padY,
    required this.btnText,
    this.borderRadius,
    this.bgColor,
    this.textColor,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.white,
        border: Border.all(color: borderColor??Colors.transparent),
        borderRadius: BorderRadius.circular(borderRadius ?? 12.sp),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading == true ? null : onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),

          child: Container(
            height: height,
            width: width,
          

            padding: EdgeInsets.symmetric(
              horizontal: padX ?? 0,
              vertical: padY ?? 10.h,
            ),

            child: Center(
              child:
                  isLoading == true
                      ? SizedBox(
                        height: 22.w,
                        width: 22.h,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 3.sp,
                        ),
                      )
                      : Text(
                        btnText,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: textSize ?? 16.sp,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

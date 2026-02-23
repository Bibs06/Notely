import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final EdgeInsets? padding;
  final EdgeInsets? margin;


  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.margin,
    this.padding,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      
    ),
  });

  const ShimmerWidget.circular({
    super.key,
    this.width = double.infinity,
    this.padding,
    this.margin,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
period: const Duration(milliseconds: 1000),
        baseColor: const Color(0xFFCFD4DA),
highlightColor: const Color(0xFFFFFFFF),
        child: Container(
          width: width,
          padding: padding,
          margin: margin,
          height: height,
          decoration:
              ShapeDecoration(shape: shapeBorder, color: Colors.grey[400]!),
        ));
  }
}

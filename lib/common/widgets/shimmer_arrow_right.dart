import 'package:flutter/material.dart';
import 'package:kevents/common/constants.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerArrowRight extends StatelessWidget {
  const ShimmerArrowRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 750),
      baseColor: kWhite,
      highlightColor: Colors.white10,
      child: Row(children: [
        Align(
            widthFactor: 0.4,
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white.withOpacity(0.5),
            )),
        Align(
            widthFactor: 0.4,
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white.withOpacity(0.5),
            )),
        Align(
            widthFactor: .4,
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white.withOpacity(0.5),
            )),
      ]),
    );
  }
}

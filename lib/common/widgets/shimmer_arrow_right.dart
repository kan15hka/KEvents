import 'package:flutter/material.dart';
import 'package:kevents/common/constants.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerArrowsRight extends StatelessWidget {
  const ShimmerArrowsRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: Duration(milliseconds: 750),
      baseColor: kWhite,
      highlightColor: Colors.white10,
      child: const Row(children: [
        Align(
            widthFactor: 0.4,
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
            )),
        Align(
            widthFactor: 0.4,
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
            )),
        Align(
            widthFactor: .4,
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
            )),
      ]),
    );
  }
}

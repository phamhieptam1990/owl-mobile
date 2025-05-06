import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCheckIn extends StatelessWidget {
  final double height;
  final int countLoop;

  const ShimmerCheckIn({
    Key? key,
    this.height = 40.0, // Gán giá trị mặc định
    this.countLoop = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: ListView.builder(
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(
                    bottom: 1.0, top: 8.0, right: 8.0, left: 8.0),
                child: Container(
                  width: double.infinity,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              itemCount: countLoop,
            ),
          ),
        ),
      ],
    );
  }
}

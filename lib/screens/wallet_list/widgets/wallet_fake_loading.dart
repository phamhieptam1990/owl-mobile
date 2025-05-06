import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WalletFakeLoadingWidget extends StatelessWidget {
  const WalletFakeLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(10),
              child: Shimmer.fromColors(
                baseColor: Color(0xffdbdbdb),
                highlightColor: const Color(0xfff2f2f2),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.grey[350]?.withOpacity(.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}

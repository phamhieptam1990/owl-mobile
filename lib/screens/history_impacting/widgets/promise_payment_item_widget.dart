import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../models/impacting_history_response.dart';

class ImpactingItemWidget extends StatelessWidget {
  final ImpactingHistoryItem data;
  final bool isLastItem;
  final int? index;
  const ImpactingItemWidget(
      {Key? key, required this.data, this.index, this.isLastItem = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemIndex = index ?? 0;
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              itemIndex % 2 == 0 ? Colors.grey[200]?.withOpacity(.2) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: 2 == 0
                    ? Color.fromARGB(24, 101, 100, 100)
                    : Color.fromARGB(19, 12, 6, 6),
                offset: Offset(0, 0),
                blurRadius: 2,
                spreadRadius: 0)
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Ngày tác động: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Text(Utils.convertTime(data.actionDate ?? 0) ?? ' ',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  'Mã tác động: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Text(data.actionCode ?? '',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  'Số điện thoại: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Text(data.phone ?? '',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  'Số tiền KH hứa thanh toán: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Text(
                        Utils.formatPrice(data.paymentAmount?.toString() ?? '',
                            hasVND: true),
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  'Ngày tác động tiếp theo: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Text(Utils.convertTime(data.nextActionDate ?? 0) ?? '',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  'Người được liên hệ: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Text(data.personContact ?? '',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Người tác động: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Text(data.contactBy ?? '',
                        maxLines: 4,
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ghi chú: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Text(data.remarks ?? '',
                        maxLines: 4,
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

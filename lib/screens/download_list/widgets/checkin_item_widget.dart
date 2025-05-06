import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/screens/download_list/models/download_list_response.dart';
import 'package:athena/widgets/common/common.dart';

import '../../../utils/utils.dart';

class CheckinItemWidget extends StatelessWidget {
  final CheckinItem value;
  final Function onTap;
  const CheckinItemWidget({Key? key, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: () {
          if (value.status == 'COMPLETED') {
            onTap.call();
          } else {
            WidgetCommon.generateDialogOKGet(
                content: 'File chỉ được phép tải ở trạng thái Hoàn Thành',
                textBtnClose: 'Đã hiểu');
          }
        },
        child: Card(
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.jobDescription ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      value.jobName ?? '',
                      style: TextStyle(fontSize: 13, color: AppColor.grey),
                    ),
                    _buildFileNameRow(),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Trạng thái: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _buildStatus(value.status ?? ''),
                            style:
                                TextStyle(fontSize: 13, color: AppColor.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Thời gian khởi tạo: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _buildTime(Utils.convertTimeStampToDateEnhance(
                                value.startTime ?? '0') ?? 0),
                            style:
                                TextStyle(fontSize: 13, color: AppColor.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(right: 12, left: 5),
                child: Icon(
                  Icons.download,
                  color: AppColor.appBar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildStatus(String status) {
    if (status == 'COMPLETED') {
      return 'Hoàn thành';
    }
    if (status == 'FAILED') {
      return 'Thất bại';
    }
    if (status == 'STARTED') {
      return 'Đang thực hiện';
    }
    return '';
  }

  // Fix 6: Create a helper method to handle the file name row with proper null safety
  Widget _buildFileNameRow() {
    // Fix the main error: proper null check for jobContext and fileName
    if (value.jobContext == null) {
      return const SizedBox(); // Return empty widget if jobContext is null
    }
    
    // Check if fileName exists and is not empty
    final fileName = value.jobContext?.fileName ?? '';
    if (fileName == null || fileName.isEmpty) {
      return const SizedBox(); // Return empty widget if fileName is null or empty
    }
    
    // If we get here, fileName exists and is not empty
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Tên File: ',
            style: TextStyle(
                fontSize: 13,
                color: AppColor.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            fileName,
            style: const TextStyle(fontSize: 13, color: AppColor.grey),
          ),
        ),
      ],
    );
  }

  String _buildTime(int time) {
    try {
      var dt = DateTime.fromMillisecondsSinceEpoch(time);
      // 24 Hour format:
      return DateFormat('dd/MM/yyyy HH:mm').format(dt); // 31/12/2000, 22:00
    } catch (_) {
      return '';
    }
  }
}

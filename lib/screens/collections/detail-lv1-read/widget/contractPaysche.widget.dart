import 'package:athena/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';

import '../../../../models/customer/contractPaysche.model.dart';

class ContactPayscheWidget extends StatelessWidget {
  final ContractPayscheModel value;
  const ContactPayscheWidget({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: () {},
        child: Card(
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Kỳ hạn vay: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Utils.returnData(value.installmentno),
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
                            'Ngày bắt đầu: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Utils.returnData(value.duedate, type: 'date'),
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
                            'Ngày kết thúc: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Utils.returnData(value.endDate, type: 'date'),
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
                            'Số tiền gốc: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Utils.returnData(value.principal, type: 'money'),
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
                            'Số tiền lãi: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Utils.returnData(value.interest, type: 'money'),
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
                            'Phí khác: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Utils.returnData(value.repaymentfee,
                                type: 'money'),
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
                            'Tổng tiền phải trả trong kỳ: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Utils.returnData(value.installmentamount,
                                type: 'money'),
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
                            'Dư nợ gốc còn lại: ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Utils.returnData(value.closingprincipal,
                                type: 'money'),
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
            ],
          ),
        ),
      ),
    );
  }
}

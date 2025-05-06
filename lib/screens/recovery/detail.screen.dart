import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/recovery/recovery.model.dart';
import 'package:athena/screens/recovery/recovery.provider.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';

class RecoveryDetailScreen extends StatefulWidget {
  final RecoveryModel recoveryModel;
  RecoveryDetailScreen({Key? key, required this.recoveryModel})
      : super(key: key);
  @override
  _RecoveryDetailScreenState createState() => _RecoveryDetailScreenState();
}

class _RecoveryDetailScreenState extends State<RecoveryDetailScreen>
    with AfterLayoutMixin {
  bool isLoading = true;
  final _recoveryProvider = getIt<RecoveryProvider>();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'RecoveryDetailScreen');
  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    try {
      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      isLoading = false;
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Widget infomationContactWidget() {
    return Card(
        child: Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 0, right: 30, top: 20),
                child: Text('Chi tiết',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: AppFont.fontSize16,
                        fontWeight: FontWeight.bold)),
              )),
          Divider(color: AppColor.blackOpacity),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.templateCode),
            decoration: InputDecoration(
                labelText: 'Mã thư',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.templateDesc),
            decoration: InputDecoration(
                labelText: 'Mô tả',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue:
                Utils.returnDataDateTime(this.widget.recoveryModel.runDate  ?? DateTime.now()),
            decoration: InputDecoration(
                labelText: 'Ngày hệ thống',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.clientName),
            decoration: InputDecoration(
                labelText: 'Phân bổ Unit',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.assignToEmail),
            decoration: InputDecoration(
                labelText: 'Phân bổ Email',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.accountNumber),
            decoration: InputDecoration(
                labelText: 'Mã tài khoản',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.collector),
            decoration: InputDecoration(
                labelText: 'Người phụ trách',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.collectorMobile),
            decoration: InputDecoration(
                labelText: 'Số điện thoại người phụ trách',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.collector),
            decoration: InputDecoration(
                labelText: 'Người phụ trách',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.agencyName),
            decoration: InputDecoration(
                labelText: 'Tên agency',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            minLines: 1,
            maxLines: 3,
            initialValue: returnData(this.widget.recoveryModel.agencyAdd),
            decoration: InputDecoration(
                labelText: 'Địa chỉ agency',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.number),
            decoration: InputDecoration(
                labelText: 'Số',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.numberCode),
            decoration: InputDecoration(
                labelText: 'Mã số',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            minLines: 1,
            maxLines: 3,
            initialValue: returnData(this.widget.recoveryModel.notes),
            decoration: InputDecoration(
                labelText: 'Ghi chú',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ],
      ),
    ));
  }

  Widget khoanvayWidget() {
    return Card(
        child: Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 0, right: 30, top: 20),
                child: Text('Khoản vay',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: AppFont.fontSize16,
                        fontWeight: FontWeight.bold)),
              )),
          Divider(color: AppColor.blackOpacity),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.amountOverdue,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Tổng nợ quá hạn',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue:
                Utils.returnDataDateTime(this.widget.recoveryModel.activedDate  ?? DateTime.now()),
            decoration: InputDecoration(
                labelText: 'Ngày kích hoạt',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: Utils.returnDataDateTime(
                this.widget.recoveryModel.disbursalDate ?? DateTime.now()),
            decoration: InputDecoration(
                labelText: 'Ngày giải ngân',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.actMobile),
            decoration: InputDecoration(
                labelText: 'Số điện thoại',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.noOfInstOverdue),
            decoration: InputDecoration(
                labelText: 'Số kỳ nợ',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.tenor),
            decoration: InputDecoration(
                labelText: 'Số kỳ',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.installmentAmt,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Kỳ thanh toán',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue:
                returnData(this.widget.recoveryModel.loanAmount, type: 'money'),
            decoration: InputDecoration(
                labelText: 'Số tiền giải ngân',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: this.widget.recoveryModel.interestRate.toString(),
            decoration: InputDecoration(
                labelText: 'Lãi suất',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.totalMoneyLms,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Tổng số tiền thanh toán',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.lastDuedayPayAmt,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Lần thanh toán cuối',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: Utils.returnDataDateTime(
                this.widget.recoveryModel.firstDuedate  ?? DateTime.now()),
            decoration: InputDecoration(
                labelText: 'Kỳ đầu tiên',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: this.widget.recoveryModel.duedate.toString(),
            decoration: InputDecoration(
                labelText: 'Hạn thanh toán',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.noOfPaidMonth,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Số tiền thanh toán',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.totalPaidAmt,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Tổng số tiền thanh toán',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: Utils.returnDataDateTime(
                this.widget.recoveryModel.lastPaidDate  ?? DateTime.now()),
            decoration: InputDecoration(
                labelText: 'Ngày thanh toán cuối',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(
                this.widget.recoveryModel.amountOutstanding,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Tổng dư nợ',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(
                this.widget.recoveryModel.currentPrincipleOutstanding,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Dư nợ gốc hiện tại',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(
                this.widget.recoveryModel.currentIntOutstanding,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Dư nợ lãi hiện tại',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(
                this.widget.recoveryModel.currentChargeOutstanding,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Dư nợ phí hiện tại',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.dpd),
            decoration: InputDecoration(
                labelText: 'Số ngày quá hạn',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue:
                returnData(this.widget.recoveryModel.outDebts, type: 'money'),
            decoration: InputDecoration(
                labelText: 'Dư nợ',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.creditLimit,
                type: 'money'),
            decoration: InputDecoration(
                labelText: 'Hạn mức',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          // TextFormField(
          //   enabled: false,
          //   readOnly: true,
          //   autofocus: false,
          //   initialValue: returnData(this.widget.recoveryModel.collector),
          //   decoration: InputDecoration(
          //       labelText: 'Người phụ trách',
          //       floatingLabelBehavior: FloatingLabelBehavior.always),
          // ),

          // TextFormField(
          //   enabled: false,
          //   readOnly: true,
          //   autofocus: false,
          //   initialValue: returnData(this.widget.recoveryModel.collectorMobile),
          //   decoration: InputDecoration(
          //       labelText: 'Số điện thoại người phụ trách',
          //       floatingLabelBehavior: FloatingLabelBehavior.always),
          // ),

          // TextFormField(
          //   enabled: false,
          //   readOnly: true,
          //   autofocus: false,
          //   initialValue: returnData(this.widget.recoveryModel.collector),
          //   decoration: InputDecoration(
          //       labelText: 'Người phụ trách',
          //       floatingLabelBehavior: FloatingLabelBehavior.always),
          // ),

          // TextFormField(
          //   enabled: false,
          //   readOnly: true,
          //   autofocus: false,
          //   initialValue: returnData(this.widget.recoveryModel.agencyName),
          //   decoration: InputDecoration(
          //       labelText: 'Tên agency',
          //       floatingLabelBehavior: FloatingLabelBehavior.always),
          // ),
          // TextFormField(
          //   enabled: false,
          //   readOnly: true,
          //   autofocus: false,
          //   initialValue: returnData(this.widget.recoveryModel.agencyAdd),
          //   decoration: InputDecoration(
          //       labelText: 'Địa chỉ agency',
          //       floatingLabelBehavior: FloatingLabelBehavior.always),
          // ),
          // TextFormField(
          //   enabled: false,
          //   readOnly: true,
          //   autofocus: false,
          //   initialValue: returnData(this.widget.recoveryModel.number),
          //   decoration: InputDecoration(
          //       labelText: 'Số',
          //       floatingLabelBehavior: FloatingLabelBehavior.always),
          // ),
          // TextFormField(
          //   enabled: false,
          //   readOnly: true,
          //   autofocus: false,
          //   initialValue: returnData(this.widget.recoveryModel.numberCode),
          //   decoration: InputDecoration(
          //       labelText: 'Mã số',
          //       floatingLabelBehavior: FloatingLabelBehavior.always),
          // ),
          // TextFormField(
          //   enabled: false,
          //   readOnly: true,
          //   autofocus: false,
          //   initialValue: returnData(this.widget.recoveryModel.notes),
          //   decoration: InputDecoration(
          //       labelText: 'Ghi chú',
          //       floatingLabelBehavior: FloatingLabelBehavior.always),
          // ),
        ],
      ),
    ));
  }

  Widget customerInfomationWidget() {
    return Card(
        child: Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 0, right: 30, top: 20),
                child: Text('Thông tin khách hàng',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: AppFont.fontSize16,
                        fontWeight: FontWeight.bold)),
              )),
          Divider(color: AppColor.blackOpacity),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.clientName),
            decoration: InputDecoration(
                labelText: S.of(context).customerName,
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.idNo),
            decoration: InputDecoration(
                labelText: 'CMND',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue:
                Utils.returnDataDateTime(this.widget.recoveryModel.issueDate  ?? DateTime.now()),
            decoration: InputDecoration(
                labelText: 'Cấp ngày',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.issuePlace),
            decoration: InputDecoration(
                labelText: 'Cấp tại',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue:
                Utils.returnDataDateTime(this.widget.recoveryModel.birthday  ?? DateTime.now()),
            decoration: InputDecoration(
                labelText: 'Ngày sinh',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            minLines: 1,
            maxLines: 3,
            initialValue: returnData(this.widget.recoveryModel.perAddress),
            decoration: InputDecoration(
                labelText: 'Địa chỉ',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.perProvince),
            decoration: InputDecoration(
                labelText: 'Thành phố',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.perDistrict),
            decoration: InputDecoration(
                labelText: 'Quận huyện',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: returnData(this.widget.recoveryModel.actMobile),
            decoration: InputDecoration(
                labelText: 'Số điện thoại',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ],
      ),
    ));
  }

  Widget formDetail() {
    try {
      return Column(children: [
        Card(
            child: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: TextFormField(
            enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: this.widget.recoveryModel.applId,
            decoration: InputDecoration(
                labelText: S.of(context).ID,
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        )),
        customerInfomationWidget(),
        khoanvayWidget(),
        infomationContactWidget(),
      ]);
    } catch (e) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCommon(
            title: (this.widget.recoveryModel.type ?? '') +
                ' - ' +
                (this.widget.recoveryModel.applId ?? ''),
            lstWidget: [
              Container(
                child: InkWell(
                  onTap: () async => {
                    await this._recoveryProvider.buildActionSheet(
                        this.widget.recoveryModel, context, _scaffoldKey)
                  },
                  child: Icon(Icons.expand_more),
                ),
                width: 44,
              )
            ]),
        body: Container(
          height: AppState.getHeightDevice(context),
          width: AppState.getWidthDevice(context),
          child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: (isLoading == true)
                  ? Container(
                      height: AppState.getHeightDevice(context),
                      width: AppState.getWidthDevice(context),
                      child: ShimmerCheckIn())
                  : formDetail()),
        ));
  }

  String returnData(var data, {String type = '', String field = ''}) {
    if (!Utils.checkIsNotNull(data)) {
      return '';
    }
    if (type == 'money') {
      if (Utils.checkValueIsDouble(data)) {
        return Utils.checkIsNull(data)
            ? Utils.formatPrice(data.round().toString())
            : '';
      }
      return Utils.formatPrice(data.toString());
    }
    return data.toString();
  }

  @override
  void dispose() {
    WidgetCommon.dismissLoading();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

// Họ và tên: extraInfo.FULLNAME
// Ngày sinh: extraInfo?.DOB
// Số CMND : extraInfo.CIFID
// Ngày cấp CMND : idnoDate
// Nơi cấp CMND : idnoPlace
// Tình trạng hôn nhân : extraInfo?.MARITALSTATUS
// Số CCCD: extraInfo?.CITIZEN_ID_NUMBER
// Ngày cấp CCCD: extraInfo?.CITIZEN_ID_ISSUE_DATE
// Nơi cấp CCCD: extraInfo?.CITIZEN_ID_ISSUE_PLACE
// Dien thoai khach hàng:  extraInfo?.ACT_MOBILE
// Tên nghề nghiệp: extraInfo?.COMPANY_NAME
// Loại nghề nghiệp: JOB_DESCRIPTION
// Địa chỉ công ty: OFF_ADDRESS
// Số tài khoản: ACCOUNT_NUMBER
// Địa chỉ tạm trú: ACT_ADDRESS
// Tỉnh tạm trú: extraInfo?.ACT_PROVINCE
// Phường/Xã tạm trú: extraInfo?.ACT_PROVINCE
// Quận/Huyện tạm trú: extraInfo?.ACT_WARD
// Địa chỉ hộ khẩu: extraInfo?.ACT_DISTRICT
// Tỉnh thường trú: extraInfo?.REG_ADDRESS
// Phường/Xã hộ khẩu: extraInfo?.REG_PROVINCE
// Quận/Huyện hộ khẩu: extraInfo?.REG_WARD

// Số hợp đồng: ACCOUNT_NUMBER
// Tên sản phẩm: PRODUCT_NAME
// Số tiền vay: LOAN_AMOUNT
// Số tiền nợ (gốc + lãi + phạt): OVERDUE_AMOUNT
// Lãi quá hạn: INTEREST_OVERDUE
// Tổng dư nợ gốc còn lại (POS): PRINCIPLE_OUTSTANDING
// Dư nợ lãi: INTEREST_OUTSTANDING
// Gốc quá hạn: PRINCIPLE_OVERDUE
// Khoản thu khác : OTHER_CHARGES
// Tổng số tiền đã thanh toán : TOTAL_REPAYMENT
// Tổng tiền còn lại: REMAIN_TOTAL
// Số dư: BALANCE_AMOUNT
// Phí quá hạn: PENALTY
// Số kỳ: TERM
// Ngày giải ngân: DEAL_DATE
// Số tiền giải ngân: DISBURSEMENT_AMT
// Ngày quá hạn: dpdContract
// Nhóm nợ: BUCKET
// Tổng số tiền đã thanh toán: TOTAL_PAID
// Số tiền đóng gần nhất: LAST_PAYMENT_AMOUNT
// Ngày thanh toán gần nhất: LAST_PAYMENT_DATE
// Ngày đến hạn đầu tiên: FIRST_DUE_DATE
// Ngày bán nợ: DEBT_SALE_DATE


// Tên người tham chiếu 1: extraInfo?.REF1_NAME
// Số điện thoại người tham chiếu 1: extraInfo?.REL1_NUMBER
// Mối quan hệ người tham chiếu 1: extraInfo?.REF1_RELATIONSHIP
// Địa chỉ người tham chiếu 1: extraInfo?.REF1_WORKADD
// Tên người tham chiếu 2 : extraInfo?.REF2_NAME
// Số điện thoại người tham chiếu 2: extraInfo?.REF2_NUMBER
// Mối quan hệ người tham chiếu 2: extraInfo?.REF2_RELATIONSHIP
// Địa chỉ người tham chiếu 2: extraInfo?.REF2_WORKADD


// Ngày đến hạn: DUE_DATE
// Số tiền thanh toán hàng tháng: INSTALLMENT
// Ngày quá hạn : INSTALLMENT
// Tổng nợ mới sau tính toán : NEW_AMOUNT

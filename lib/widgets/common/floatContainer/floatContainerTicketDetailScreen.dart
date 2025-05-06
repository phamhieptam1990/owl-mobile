import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/utils/utils.dart';

import '../../../generated/l10n.dart';
import '../../../getit.dart';
import '../../../utils/global-store/user_info_store.dart';

class FloatContainerTicketDetailScreen extends StatelessWidget {
  final TicketModel? ticketModel;  // Mark as nullable
  
  FloatContainerTicketDetailScreen({
    Key? key,
    this.ticketModel,
  }) : super(key: key);

  Widget addFloatButton(BuildContext context) {
    final fieldTypeCode = ticketModel?.fieldTypeCode;  // Use null-aware operator
    final List<SpeedDialChild> childrenWidgetFieldType = [];
    final _userInfoStore = getIt<UserInfoStore>();
    String actionGroupCode = '';
    String actionGroupName = '';
    if (fieldTypeCode != null) {
      for (var fieldType in fieldTypeCode) {
        actionGroupCode = fieldType['actionGroupCode'] ?? '';  // Add null safe access
        actionGroupName = fieldType['actionGroupName'] ?? '';  // Add null safe access
        if (ticketModel?.feType == ActionPhone.LOAN) {
          if (actionGroupCode == FieldTicketConstant.PTP) {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                label: S.of(context).customerPromiseToPay,
                // label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  Utils.pushName(context, RouteList.PROMISE_TO_PAYMENT,
                      params: getParamsCheckin(fieldType,
                          enableDefaultActiveTime: false))
                },
              ),
            );
          } else if (actionGroupCode == FieldTicketConstant.RTP) {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                label: S.of(context).customerRefuseToPay,
                // label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  Utils.pushName(context, RouteList.REFUSE_TO_PAYMENT,
                      params: getParamsCheckin(fieldType))
                },
              ),
            );
          } else if (actionGroupCode == FieldTicketConstant.PAY) {
            if (Utils.isTenantTnex(_userInfoStore)) {
            } else {
              childrenWidgetFieldType.add(
                SpeedDialChild(
                  child: Icon(Icons.edit, color: Colors.white),
                  backgroundColor: Theme.of(context).primaryColor,
                  label: S.of(context).customerPartialPayment,
                  // label: actionGroupName,
                  labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                  labelBackgroundColor: Colors.white,
                  onTap: () => {
                    Utils.pushName(context, RouteList.PARTICAL_PAYMENT,
                        params: getParamsCheckin(fieldType))
                  },
                ),
              );
            }
          } else if (actionGroupCode == FieldTicketConstant.OTHER) {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                label: S.of(context).otherCheckIn,
                // label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  Utils.pushName(context, RouteList.OTHER_CHECK_IN,
                      params: getParamsCheckin(fieldType))
                },
              ),
            );
          } else if (actionGroupCode == FieldTicketConstant.OTHER_CALL) {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                // label: S.of(context).otherCheckInC,
                label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  Utils.pushName(context, RouteList.OTHER_CHECK_IN,
                      params: getParamsCheckin(fieldType,
                          enableDefaultActiveTime: false))
                },
              ),
            );
          }
        } else if (ticketModel?.feType == ActionPhone.CARD) {
          if (actionGroupCode == FieldTicketConstant.C_PTP) {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                // label: S.of(context).customerPromiseToPayC,
                label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  // Utils.pushName(context, RouteList.PROMISE_TO_PAYMENT,
                  //     params: ticketModel)
                  Utils.pushName(context, RouteList.PROMISE_TO_PAYMENT,
                      params: getParamsCheckin(fieldType,
                          enableDefaultActiveTime: false))
                },
              ),
            );
          } else if (actionGroupCode == FieldTicketConstant.C_RTP) {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                // label: S.of(context).customerRefuseToPayC,
                label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  // Utils.pushName(context, RouteList.REFUSE_TO_PAYMENT,
                  //     params: ticketModel)
                  Utils.pushName(context, RouteList.REFUSE_TO_PAYMENT,
                      params: getParamsCheckin(fieldType))
                },
              ),
            );
          } else if (actionGroupCode == FieldTicketConstant.C_PAY) {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                // label: S.of(context).customerPartialPaymentC,
                label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  Utils.pushName(context, RouteList.PARTICAL_PAYMENT,
                      params: getParamsCheckin(fieldType))
                },
              ),
            );
          } else if (actionGroupCode == FieldTicketConstant.C_OTHER) {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                // label: S.of(context).otherCheckInC,
                label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  Utils.pushName(context, RouteList.OTHER_CHECK_IN,
                      params: getParamsCheckin(fieldType))
                },
              ),
            );
          } else if (actionGroupCode == FieldTicketConstant.OTHER_CALL) {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                // label: S.of(context).otherCheckInC,
                label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  Utils.pushName(context, RouteList.OTHER_CHECK_IN,
                      params: getParamsCheckin(fieldType,
                          enableDefaultActiveTime: false))
                },
              ),
            );
          } else {
            childrenWidgetFieldType.add(
              SpeedDialChild(
                child: Icon(Icons.edit, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                // label: S.of(context).otherCheckInC,
                label: actionGroupName,
                labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                labelBackgroundColor: Colors.white,
                onTap: () => {
                  Utils.pushName(context, RouteList.OTHER_CHECK_IN,
                      params: getParamsCheckin(fieldType))
                },
              ),
            );
          }
        }
      }
    }
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 20.0),
      icon: Icons.add,
      activeIcon: Icons.close,
      closeManually: false,
      overlayColor: Colors.black,
      overlayOpacity: 0.3,
      heroTag: 'speed-dial-hero-tag-2',
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 2.0,
      shape: CircleBorder(),
      children: childrenWidgetFieldType,
    );
  }

  getParamsCheckin(var fieldType, {bool enableDefaultActiveTime = true}) {
    return {
      'ticketModel': ticketModel,
      'actionGroupId': fieldType['id'],
      'actionGroupCode': fieldType['actionGroupCode'],
      'actionGroupName': fieldType['actionGroupName'],
      'enableDefaultActiveTime': enableDefaultActiveTime
    };
  }

  @override
  Widget build(BuildContext context) {
    return addFloatButton(context);
  }
}

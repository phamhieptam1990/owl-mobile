import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:athena/common/constants.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/utils.dart';


class FloatContainerHomeScreen extends StatelessWidget {
  final VoidCallback? onRecordTLLocation;
  final hiveService = new HiveDBService();
  FloatContainerHomeScreen({Key? key, this.onRecordTLLocation})
      : super(key: key);

  Widget addFloatButton(BuildContext context) {
    List<SpeedDialChild> lstSpeedDial = [
      SpeedDialChild(
        child: Icon(Icons.note_alt, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        label: S.of(context).addComplainCustomer,
        labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
        labelBackgroundColor: Colors.white,
        // visible:
        //     _userInfoStore.checkPerimission(ScreenPermission.COMPLAINT_TICKET),
        onTap: () {
          if (OfflineService.isFeatureValid(FEATURE_APP.CUSTOMER_COMPLAIN)) {
            Utils.pushName(context, RouteList.CUSTOMER_COMPLAIN_SCREEN);
          }
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.person_add, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        label: S.of(context).addSupportRequire,
        labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
        labelBackgroundColor: Colors.white,
        // visible:
        //     _userInfoStore.checkPerimission(ScreenPermission.SUPPORT_TICKET),
        onTap: () async {
          if (OfflineService.isFeatureValid(FEATURE_APP.CUSTOMER_REQUEST)) {
            Utils.pushName(context, RouteList.CUSTOMER_REQUEST_SCREEN);
            // doSomeThing(context);
          }
        },
      ),
      // SpeedDialChild(
      //   child: Icon(Icons.location_on_outlined, color: Colors.white),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   label: 'Lưu địa điểm',
      //   labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
      //   labelBackgroundColor: Colors.white,
      //   visible: _userInfoStore.checkPerimission(
      //       FuncPermission.MB_FUNCTION_CREATEGPSLOGFORICOLLECT),
      //   onTap: () {
      //     onRecordTLLocation?.call();
      //   },
      // ),
      // SpeedDialChild(
      //   child: Icon(Icons.location_on_outlined, color: Colors.white),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   label: 'Dev test Tracking location',
      //   labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
      //   labelBackgroundColor: Colors.white,
      //   visible: StorageHelper.isDevTeam(),
      //   onTap: () {
      //     Utils.submitLocation();
      //   },
      // ),
      // SpeedDialChild(
      //   child: Icon(Icons.location_on_outlined, color: Colors.white),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   label: 'Dev test crashes',
      //   labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
      //   labelBackgroundColor: Colors.white,
      //   visible: !IS_PRODUCTION_APP || StorageHelper.isDevTeam(),
      //   onTap: () async {
      //     throw Exception('Some arbitrary error');
      //   },
      // ),
      // SpeedDialChild(
      //   child: Icon(Icons.location_on_outlined, color: Colors.white),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   label: 'Write App Install',
      //   labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
      //   labelBackgroundColor: Colors.white,
      //   visible: !IS_PRODUCTION_APP || StorageHelper.isDevTeam(),
      //   onTap: () async {
      //     TrackingInstallingDevice().writeAppInstalled();
      //   },
      // )
    ];

    return SpeedDial(
      activeIcon: Icons.close,
      icon: Icons.add,
      closeManually: false,
      overlayColor: Colors.black,
      overlayOpacity: 0.3,
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: lstSpeedDial,
    );
  }

  @override
  Widget build(BuildContext context) {
    return addFloatButton(context);
  }
}

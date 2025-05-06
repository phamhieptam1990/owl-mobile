import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:athena/common/constants.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/utils.dart';

class FloatContainerCheckBoxCollectionScreen extends StatelessWidget {
  FloatContainerCheckBoxCollectionScreen({
    Key? key,
  }) : super(key: key);

  Widget addFloatButton(BuildContext context) {
    return SpeedDial(
      // both default to 16
      // marginRight: 18,
      childPadding: const EdgeInsets.only(bottom: 20),
      // animatedIcon: AnimatedIcons.add_event,
      // animatedIconTheme: IconThemeData(size: 22.0),
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
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          label: S.of(context).noteActionDiary,
          labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
          labelBackgroundColor: Colors.white,
          onTap: () async => {
            if (OfflineService.isFeatureValid(FEATURE_APP.CUSTOMER_REQUEST))
              {Utils.pushName(context, RouteList.CUSTOMER_COMPLAIN_SCREEN)}
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.cancel, color: Colors.white),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          label: S.of(context).addSupportRequire,
          labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
          labelBackgroundColor: Colors.white,
          onTap: () => {
            if (OfflineService.isFeatureValid(FEATURE_APP.CUSTOMER_REQUEST))
              {Utils.pushName(context, RouteList.CUSTOMER_REQUEST_SCREEN)}
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return addFloatButton(context);
  }
}

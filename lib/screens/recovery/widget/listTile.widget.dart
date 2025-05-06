import 'package:flutter/material.dart';
import 'package:athena/models/recovery/recovery.model.dart';

class LeadingTitleRecovery extends StatelessWidget {
  final RecoveryModel recoveryModel;
  LeadingTitleRecovery({Key? key, required this.recoveryModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new SizedBox(height: 4.0),
        Row(
          children: [
            Icon(
              Icons.perm_device_information,
              size: 15.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Text(
                ('Mã số HĐ: ' + recoveryModel.applId! ?? ''),
                style: TextStyle(fontSize: 12.0, color: Colors.black54),
              ),
            )
          ],
        ),
        new SizedBox(height: 4.0),
      ],
    );
  }
}

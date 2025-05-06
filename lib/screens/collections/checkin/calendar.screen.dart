import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/checkin.provider.dart';
import 'package:provider/provider.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/widgets/common/collections/footerButtonOK.widget.dart';
import 'package:athena/widgets/common/common.dart';

class CalendarTicketScreen extends StatefulWidget {
  CalendarTicketScreen({Key? key}) : super(key: key);
  @override
  _CalendarTicketScreenState createState() => _CalendarTicketScreenState();
}

class _CalendarTicketScreenState extends State<CalendarTicketScreen>
    with AfterLayoutMixin {
  TicketModel? ticketModel;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'CalendarScreen');
  final _checkInProvider = getIt<CheckInProvider>();

  var _checked = {
    'checked5': {'value': 5, 'isChecked': true},
    'checked30': {'value': 30, 'isChecked': false},
    'checked60': {'value': 60, 'isChecked': false},
    'checked90': {'value': 90, 'isChecked': false},
  };
  var _checkedSubmit = {'value': 5, 'isChecked': true};
  String _time = '';
  DateTime? _dateValuePicker;
  DateTime? _now;
  @override
  initState() {
    super.initState();
    _now = _checkInProvider.checkIn != null
        ? _checkInProvider.checkIn
        : DateTime.now().add(
            Duration(minutes: AppStateConfigConstant.DEFAULT_TIME_CHECKIN));
    _time = Utils.convertTime(_now?.millisecondsSinceEpoch ??0, timeFormat: 'HH:mm');
    _dateValuePicker = _now;
    _checkedSubmit = _checkInProvider.durations != null
        ? _checkInProvider.durations
        : {'value': 5, 'isChecked': true};
    if (_checkInProvider.durations != null) {
      _checked['checked5']!['isChecked'] = false;
      _checked['checked30']!['isChecked'] = false;
      _checked['checked60']!['isChecked'] = false;
      _checked['checked90']!['isChecked'] = false;
      _checked["checked" + _checkInProvider.durations!['value'].toString()]!['isChecked'] = true;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  void handleData() async {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckInProvider>(
        create: (context) => _checkInProvider,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBarCommon(
                title: S.of(context).timeScheduleNext, lstWidget: []),
            body: Container(
              height: AppState.getHeightDevice(context),
              width: AppState.getWidthDevice(context),
              child: buildForm(),
            ),
            bottomNavigationBar: FooterButonOKWidget(
              callbackOK: () async {
                submitForm(context);
              },
            )));
  }

  void submitForm(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_checkedSubmit['isChecked'] == false) {
      return WidgetCommon.showSnackbar(
          _scaffoldKey, "Vui lòng chọn thời lượng.");
    }
    try {
      _checkInProvider.checkIn = _dateValuePicker;
      _checkInProvider.durations = _checkedSubmit;
      final String timeSubmit = Utils.convertTime(
              _dateValuePicker?.millisecondsSinceEpoch ??0,
              timeFormat: 'HH:mm') +
          " - " +
          _checkedSubmit['value'].toString() +
          " " +
          S.of(context).mins;
      Navigator.pop(context, timeSubmit);
    } catch (e) {}
  }

  Widget formDetail() {
    return Card(
        margin: EdgeInsets.all(7.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 7.0, top: 10.0, right: 7.0, bottom: 0.0),
              child: Text(
                S.of(context).time,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: () {
                DatePicker.showDateTimePicker(context, showTitleActions: true,
                    onChanged: (date) {
                  // print('change $date in time zone ' +
                  //     date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  _time = Utils.convertTime(date.millisecondsSinceEpoch,
                      timeFormat: 'HH:mm');
                  _dateValuePicker = date;
                  setState(() {});
                }, minTime: _now, currentTime: _now, locale: LocaleType.vi);
              },
              child: ListTile(
                title: Text(_time),
                leading: Icon(Icons.calendar_today),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          ],
        ));
  }

  Widget timeContainer() {
    return Card(
        margin: EdgeInsets.all(7.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 7.0, top: 10.0, right: 7.0, bottom: 0.0),
              child: Text(
                S.of(context).timeSchedule,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            CheckboxListTile(
                title: Text("5 " + S.of(context).mins),
                controlAffinity: ListTileControlAffinity.platform,
                activeColor: Theme.of(context).primaryColor,
                value: _checked['checked5']!['isChecked'] as bool? ?? false,
                onChanged: (bool? value) {
                  removeChecked('checked5', value!);
                }),
            CheckboxListTile(
                title: Text("30 " + S.of(context).mins),
                controlAffinity: ListTileControlAffinity.platform,
                activeColor: Theme.of(context).primaryColor,
                value: _checked['checked30']!['isChecked'] as bool? ?? false,
                onChanged: (bool? value) {
                  removeChecked('checked30', value!);
                }),
            CheckboxListTile(
                title: Text("60 " + S.of(context).mins),
                controlAffinity: ListTileControlAffinity.platform,
                activeColor: Theme.of(context).primaryColor,
                value: _checked['checked60']!['isChecked'] as bool? ?? false,
                onChanged: (bool? value) {
                  removeChecked('checked60', value!);
                }),
            CheckboxListTile(
                title: Text("90 " + S.of(context).mins),
                controlAffinity: ListTileControlAffinity.platform,
                activeColor: Theme.of(context).primaryColor,
                value: _checked['checked90']!['isChecked'] as bool? ?? false,
                onChanged: (bool? value) {
                  removeChecked('checked90', value!);
                }),
          ],
        ));
  }

  void removeChecked(String key, bool val) {
    _checked['checked5']!['isChecked'] = false;
    _checked['checked30']!['isChecked'] = false;
    _checked['checked60']!['isChecked'] = false;
    _checked['checked90']!['isChecked'] = false;
    if (val == true) {
      _checked[key]!['isChecked'] = val;
    }
    _checkedSubmit = _checked[key]!;
    setState(() {});
  }

  Widget buildForm() {
    return Column(children: [
      Expanded(
        child: ListView(
          children: [formDetail(), timeContainer()],
        ),
      )
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class CustomPicker extends CommonPickerModel {
  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }
}

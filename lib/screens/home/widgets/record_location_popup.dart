import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/widgets/common/common.dart';

class RecordLocationPopup extends StatefulWidget {
  final String title;

  final Function(Position, String) onsubmit;

  RecordLocationPopup({Key? key, required this.onsubmit, this.title = ''})
      : super(key: key);

  @override
  _RecordLocationPopupState createState() => _RecordLocationPopupState();
}

class _RecordLocationPopupState extends State<RecordLocationPopup> {
  TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Position? position;
  @override
  void initState() {
    fetchLocation();
    super.initState();
  }

  void fetchLocation() async {
    try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }

      bool permission =
          await PermissionAppService.checkServiceEnabledLocation();

      if (permission) {
        position = await PermissionAppService.getCurrentPosition();
        if (position == null) {
          isLoading = false;
          setState(() {});
          showGetLocationError();
          return;
        }
        String address = await VietMapService().getAddressFromLongLatVMap(
            position?.latitude ?? 0.0, position?.longitude ?? 0.0, context);

        if (address.isNotEmpty) {
          isLoading = false;
          _controller.text = address;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
          showGetLocationError();
        }
      }
    } catch (e) {
      isLoading = false;
      showGetLocationError();
      setState(() {});
    }
  }

  void showGetLocationError() {
    WidgetCommon.showSnackbarErrorGet(
        'Lấy ví trí thất bại, vui lòng thử lại sau!');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x25606060),
                  offset: Offset(2, -4.0),
                  blurRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              children: [
                buildHeader(),
                SizedBox(
                  height: 20,
                ),
                buildInputOtherType(),
                SizedBox(
                  height: 20,
                ),
                Spacer(),
                buildBottomButton(),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputOtherType({bool enableEdit = false}) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: TextFormField(
          controller: _controller,
          readOnly: true,
          decoration: new InputDecoration(
              labelText: "Địa điểm",
              fillColor: AppColor.appBar,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(16.0),
                borderSide: new BorderSide(),
              ),
              suffixIcon: InkWell(
                child: buildLoadingLocation(),
                onTap: () {
                  fetchLocation();
                },
              )),
          keyboardType: TextInputType.multiline,
          validator: (value) =>
              value == null || value.isEmpty ? 'Không tìm thấy địa điểm' : null,

          style: new TextStyle(
            fontFamily: "Poppins",
          ),
          minLines: 1,
          maxLines: 4,
        ),
      ),
    );
  }

  Widget buildBottomButton() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Đóng".toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            style: ButtonStyle(
                padding:
                    WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                backgroundColor:
                    WidgetStateProperty.all<Color>(Color(0xFFF2F2F2)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
          ),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ElevatedButton(
            onPressed: () {
             if (_formKey.currentState != null &&
                  _formKey.currentState!.validate() &&
                  position != null) {

                Navigator.of(context).pop();
                widget.onsubmit.call(position!, _controller.text);
              }
            },
            child: Text("Ghi nhận".toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            style: ButtonStyle(
                padding:
                    WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    WidgetStateProperty.all<Color>(AppColor.appBar),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: AppColor.appBar)))),
          ),
        )),
      ],
    );
  }

  Widget buildLoadingLocation() {
    if (!isLoading) {
      return Container(child: Icon(Icons.refresh, color: AppColor.appBar));
    }
    return WidgetCommon.buildCircleLoading(
        widthSB: 20.0, heightSB: 20.0, pWidth: 20.0);
  }

  Container buildHeader() {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x25606060),
            offset: Offset(2, -4.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.title ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A5A5A),
                  fontSize: 20,
                  fontFamily: 'Roboto'),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 9, right: 19),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Image.asset('assets/images/ic_close.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

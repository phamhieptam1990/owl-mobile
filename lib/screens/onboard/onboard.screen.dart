import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/utils/services/geolocation.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';

class OnBoardScreen extends StatefulWidget {
  OnBoardScreen({Key? key}) : super(key: key);

  @override
  OnBoardScreenState createState() => new OnBoardScreenState();
}

class OnBoardScreenState extends State<OnBoardScreen> {
  List<ContentConfig> slides = [];
  int numberSLide = 1;
  GeoPositionBackgroundService _geoPositionBackgroundService =
      new GeoPositionBackgroundService();
  @override
  void initState() {
    super.initState();

    slides.add(
      new ContentConfig(
          title: "Thông tin cuộc gọi",
          widgetDescription: Text(
            'Athena Owl hiện sẽ truy cập thông tin cuộc gọi, và xem lịch sử cuộc gọi trên thiết bị, để kiểm tra kết quả làm việc của bạn mỗi ngày.',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
            maxLines: 110,
            overflow: TextOverflow.ellipsis,
          ),
          centerWidget: Padding(
            child: Icon(
              Icons.phone_in_talk_rounded,
              color: Colors.white,
              size: 100.0,
            ),
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
          ),
          backgroundColor: AppColor.primary),
    );
    slides.add(
      new ContentConfig(
          title: "Truy cập vị trí",
          widgetDescription: Text(
            "Athena Owl thu nhập dữ liệu vị trí của bạn để tính toán quãng đường bạn di chuyển từ đó sẽ đề ra những hợp đồng phù hợp với bạn nhất sau này.",
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
            maxLines: 110,
            overflow: TextOverflow.ellipsis,
          ),
          centerWidget: Padding(
            child: Icon(
              Icons.place,
              color: Colors.white,
              size: 100.0,
            ),
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
          ),
          backgroundColor: AppColor.dashBoard2),
    );
  }

  void onDonePress() async {
    await StorageHelper.setBool(AppStateConfigConstant.IS_FIRST_ENTER, true);

    // await PermissionAppService.checkServiceEnabledLocation();
    // await _geoPositionBackgroundService.handlePermission();
    await Geolocator.requestPermission();
    Utils.navigateToReplacement(context, RouteList.LOGIN_SCREEN);
  }

  Widget renderNextBtn() {
    return TextButton(
      child: Text(
        'Đồng ý',
        style: TextStyle(color: AppColor.white),
      ),
      onPressed: () async {
        if (numberSLide == 1) {
          await Permission.phone.request();
        }
        this.goToTab!(numberSLide);
        numberSLide++;
      },
    );
  }

  Widget renderSkipBtn() {
    return TextButton(
      child: Text(
        'Bỏ qua',
        style: TextStyle(color: AppColor.white),
      ),
      onPressed: () async {
        this.goToTab!(numberSLide);
        numberSLide++;
      },
    );
  }

  Widget renderDoneBtn() {
    return TextButton(
      child: Text(
        'Hoàn Tất',
        style: TextStyle(color: AppColor.white),
      ),
      onPressed: () async {
        this.onDonePress();
      },
    );
  }

  Function? goToTab;

  void refFuncGoToTab() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IntroSlider(
          isAutoScroll: false,
          listContentConfig: this.slides,
          isScrollable: false,
          renderNextBtn: this.renderNextBtn(),
          renderSkipBtn: this.renderSkipBtn(),
          renderDoneBtn: this.renderDoneBtn(),
          // hideStatusBar: false,
          refFuncGoToTab: (refFunc) {
            this.goToTab = refFunc;
          },
          scrollPhysics: const NeverScrollableScrollPhysics(),
          indicatorConfig: IndicatorConfig(
            isShowIndicator: true,
            colorIndicator: Colors.white,
            sizeIndicator: 7.0,
            typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
          ),
          navigationBarConfig:
              NavigationBarConfig(navPosition: NavPosition.bottom)),

      // showDotIndicator: false,
      // verticalScrollbarBehavior: scrollbarBehavior.HIDE
    );
    // return Scaffold(
    //     // resizeToAvoidBottomPadding: false,
    //     resizeToAvoidBottomInset: false,
    //     body: IntroSlider(
    //       slides: this.slides,
    //         renderNextBtn: this.renderNextBtn(),
    //         renderSkipBtn: this.renderSkipBtn(),
    //         renderDoneBtn: this.renderDoneBtn(),
    //         hideStatusBar: false,
    //         refFuncGoToTab: (refFunc) {
    //           this.goToTab = refFunc;
    //         },
    //         scrollPhysics: const NeverScrollableScrollPhysics(),
    //         showDotIndicator: false,
    //     ));
  }
}

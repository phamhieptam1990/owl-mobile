import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/category/locality.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/category/category.service.dart';
import 'package:athena/utils/services/debouncer.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/collections/footerButtonOKCANCEL.widget.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';

import '../show_toturial_manager.dart';
import 'tutorial.widget.dart';

class LocalityScreen extends StatefulWidget {
  final String? type;
  final LocalityModel? cityModel;
  final LocalityModel? provinceModel;
  LocalityScreen(
      {Key? key, required this.type, required this.cityModel, required this.provinceModel})
      : super(key: key);
  @override
  _LocalityScreenState createState() => _LocalityScreenState();
}

class _LocalityScreenState extends State<LocalityScreen> with AfterLayoutMixin {
  bool isFirstEnter = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _keywordController = new TextEditingController();
  final _categoryProvider = new CategorySingeton();
  final _categoryService = new CategoryService();

  List<TargetFocus> targets = <TargetFocus>[];

  List<LocalityModel> listData = [];
  LocalityModel? locality;
  final _debouncer = Debouncer();
  String lastKeywordSearch = '';

  GlobalKey keyRefreshLocality = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBarCommon(title: "Tìm kiếm", lstWidget: [
          IconButton(
            key: keyRefreshLocality,
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await this.loadLocality();
            },
          ),
        ]),
        body: Scrollbar(
          child: buildScreen(),
        ),
        bottomNavigationBar: FooterButonOKCANCELWidget(callbackOK: () async {
          Navigator.pop(context, locality);
        }, callbackCancel: () async {
          // setState(() {});
        }));
  }

  Widget buildScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _keywordController,
          validator: (val) => Utils.isRequire(context, val ?? ''),
          onFieldSubmitted: (term) async {
            if (term.isEmpty) {
              return;
            }
            if (term.length <= 1) {
              return;
            }
            handleSearch();
          },
          style: TextStyle(fontSize: 16.0, color: Colors.black),
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(10.0),
              labelText: "Tìm kiếm theo tên",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        Expanded(child: buildEventList())
      ],
    );
  }

  Widget buildEventList() {
    if (isFirstEnter) {
      return Container(
        child: ShimmerCheckIn(),
        height: AppState.getHeightDevice(context),
        width: AppState.getWidthDevice(context),
      );
    }
    if (this.listData.length == 0) {
      return NoDataWidget();
    }
    return ListView.builder(
      itemBuilder: (c, i) => buildItemListView(i),
      itemCount: listData.length,
    );
  }

  Widget buildItemListView(int index) {
    LocalityModel detail = this.listData[index];
    return InkWell(
      onTap: () {
        Navigator.pop(context, detail);
      },
      child: ListTile(
          contentPadding:
              EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
          title: Text(detail.name ?? '')),
    );
  }

  Future<void> handleSearch() async {
    try {
      this.listData = [];
      String keyword = _keywordController.text.toLowerCase();
      if (widget.type == CollectionTicket.CITY) {
        for (LocalityModel localityModel in this._categoryProvider.lstCity) {
          final String name = localityModel.name?.toLowerCase() ?? '';
          if (name.indexOf(keyword) > -1) {
            this.listData.add(localityModel);
          }
        }
      } else if (widget.type == CollectionTicket.PROVINCE) {
        for (LocalityModel localityModel
            in this._categoryProvider.lstProvince) {
          final String name = localityModel.name?.toLowerCase() ?? '';
          if (name.indexOf(keyword) > -1) {
            this.listData.add(localityModel);
          }
        }
      } else if (widget.type == CollectionTicket.WARD) {
        for (LocalityModel localityModel in this._categoryProvider.lstWard) {
          final String name = localityModel.name?.toLowerCase() ?? '';
          if (name.indexOf(keyword) > -1) {
            this.listData.add(localityModel);
          }
        }
      }
    } catch (e) {
    } finally {
      setState(() {});
    }
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    try {
      await Future.delayed(Duration(milliseconds: 100));
      initData();
      bool isShowed = await ShowTutorialManager.getShowedLocality();
      if (!isShowed) {
        // showTutorial();
      }
    } catch (e) {
    } finally {
      isFirstEnter = false;
      setState(() {});
    }
  }

  void initData() {
    try {
      this.listData = [];
      if (widget.type == CollectionTicket.CITY) {
        this.listData = this._categoryProvider.lstCity;
      } else if (widget.type == CollectionTicket.PROVINCE) {
        if (Utils.checkIsNotNull(widget.cityModel)) {
          this._categoryProvider.loadProvince(widget?.cityModel);
          this.listData = this._categoryProvider.lstProvince;
        }
      } else if (widget.type == CollectionTicket.WARD) {
        if (Utils.checkIsNotNull(widget.provinceModel) &&
            Utils.checkIsNotNull(widget.cityModel)) {
          this._categoryProvider.loadWard(widget?.provinceModel);
          this.listData = this._categoryProvider.lstWard;
        }
      }
    } catch (e) {
    } finally {
      setState(() {});
    }
  }

  Future<void> onSearchChanged() async {
    _debouncer(() async {
      String text = _keywordController.text.toString();
      if (text.length <= 1) {
        if (listData.length <= 3) {
          initData();
        }
        return;
      }
      if (lastKeywordSearch != text) {
        lastKeywordSearch = text;
        await handleSearch();
      }
    });
  }

  Future<void> loadLocality() async {
    try {
      this._categoryProvider.getlstLocalityModel.clear();
      this.listData = [];
      WidgetCommon.showLoading(status: 'Load tỉnh thành');
      final locality = await _categoryService.getAllLocality();
      if (Utils.checkIsNotNull(locality)) {
        final data = locality.data;
        if (Utils.checkIsNotNull(data)) {
          final dataLocality = data['data'];
          if (Utils.isArray(dataLocality)) {
            this._categoryProvider.categoryAll['locality'] = dataLocality;
            if (this._categoryProvider.getlstLocalityModel.isEmpty) {
              List<LocalityModel> lstLocality = [];
              for (var data in dataLocality) {
                lstLocality.add(LocalityModel.fromJson(data));
              }
              this._categoryProvider.lstLocalityModel = lstLocality;
              this.initData();
            }
          }
        }
      }
      WidgetCommon.dismissLoading();
    } catch (e) {
      WidgetCommon.dismissLoading();
    }
  }

  void showTutorial() {
    initTargets();
    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "Bỏ qua",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {},
      onClickTarget: (target) {},
      onSkip: () {
        try {
          return true;
          // ShowTutorialManager.saveShowLocalityKey();
        } catch (e) {
          return false;
        }
        // Navigator.pop(context);
      },
      onClickOverlay: (target) {},
    )..show(context: context);
    ShowTutorialManager.saveShowLocalityKey();
  }

  initTargets() {
    targets.add(
      TargetFocus(
        identify: "keyRefreshLocality",
        keyTarget: keyRefreshLocality,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return ToturialWidget(
                title: 'Khi cần tải lại danh sách',
                description:
                    'Lưu ý: hành động này có thể mất 10 đến 15 giây để tải lại!',
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _keywordController.addListener(onSearchChanged);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }
}

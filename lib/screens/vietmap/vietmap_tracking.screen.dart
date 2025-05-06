import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:athena/screens/vietmap/vietmap_list_tracking/vietmap_list_tracking.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/employee/employee.tracking.model.dart';
import 'package:athena/models/map/location.model.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'vietmap.provider.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/utils/services/debouncer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:search_map_place_v2/search_map_place_v2.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class VietTrackingMapScreen extends StatefulWidget {
  VietTrackingMapScreen({Key? key}) : super(key: key);

  @override
  _TrackingMapScreenState createState() => _TrackingMapScreenState();
}

class _TrackingMapScreenState extends State<VietTrackingMapScreen>
    with AfterLayoutMixin {
  final _mapService = new VietMapService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'VietTrackingMapScreenState');
  final _mapProvider = getIt<VietMapProvider>();
  String centervymo = 'centervymo';
  VietmapController? _mapController;
  final _formKey = new GlobalKey<FormState>();
  CameraPosition? _cameraPosition;
  bool isLoadMapComplete = false;
  LatLng? _center;
  List<Marker> _markers = <Marker>[];
  EmployeeTrackingModel? currentNode;
  final TextEditingController _radiusController = new TextEditingController();
  int currentIndex = 0;
  int _radius = 10;
  String title = '';
  Future _mapFuture = Future.delayed(Duration(milliseconds: 500), () => true);
  List<String> lstEmps = [];
  String emps = "";
  bool checkmove = false;
  final _debouncer = Debouncer(delay: Duration(milliseconds: 2000));

  @override
  void initState() {
    super.initState();
    this._radiusController.text = '10';
  }

  setController(String value) async {
    _radiusController.value = TextEditingValue(
      text: value,
      selection: TextSelection.fromPosition(
        TextPosition(offset: value.length),
      ),
    );
  }

  Future<void> handleFetchData() async {
    this.currentIndex = 0;
    _markers = <Marker>[];
    _mapProvider.clearData();
    String radius = this._radiusController.text;
    if (radius == '' || int.tryParse(radius)! <= 0) {
      WidgetCommon.dismissLoading();

      setState(() {});
      WidgetCommon.showSnackbar(
          this._scaffoldKey, S.of(context).radius_require);
      return;
    }
    try {
      Map<String, dynamic> params = {
        "appCode": APP_CONFIG.APP_CODE,
        "coordinates": {
          "longitude": _center?.longitude,
          "latitude": _center?.latitude
        },
        "radius": int.tryParse(radius),
        "actors": []
      };
      final Response response = await this
          ._mapService
          .getListGpsUserCurrent('input=' + Utils.encodeRequestJson(params));
      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData(response);
        for (var data in lstData) {
          this._mapProvider.addEmployeeTrackingModel(data);
        }
      }
    } catch (e) {
      WidgetCommon.dismissLoading();
    }
  }

  Future<void> setPosition(position) async {
    if (position != null) {
      _center = new LatLng(position.latitude, position.longitude);
    } else {
      Position? newPos = await PermissionAppService.getCurrentPosition();
      if (newPos != null && Utils.checkIsNotNull(newPos)) {
        _center = new LatLng(newPos.latitude, newPos.longitude);
      }
    }
  }

  Future<void> getPosition() async {
    Position? position = await PermissionAppService.getCurrentPosition();
    if (position != null) {
      _center = new LatLng(position.latitude, position.longitude);
    }
    }

  markerCenter() {
    // _markers.add(Marker(
    //     onTap: () async {
    //       // changeInfoCustomer(
    //       //     this._mapProvider.lstEmployeeTrackingModel.elementAt(index),
    //       //     index,
    //       //     _markers.length);
    //     },
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    //     markerId: MarkerId(centervymo),
    //     position: new LatLng(_center.latitude, _center.longitude),
    //     infoWindow: InfoWindow(title: 'Center')));
  }

  Future<void> hanleAddressToGetMarker() async {
    currentNode = null;
    try {
      WidgetCommon.showLoading();
      await handleFetchData();
      markerCenter();
      for (int index = 0;
          index < this._mapProvider.lstEmployeeTrackingModel.length;
          index++) {
        // LatLng _location = await _mapService.getLatLngFromAddress(
        //     _mapProvider.lstEmployeeTrackingModel.elementAt(index).makerId,
        //     context);
        final location = _mapProvider.lstEmployeeTrackingModel[index].coordinates;
        
        final double? latitude = double.tryParse(location?.latitude ?? '0.0') ?? 0.0;
        final double? longitude = double.tryParse(location?.longitude ?? '0.0') ?? 0.0;
        
        if (latitude != null && longitude != null) {
          final _location = LatLng(latitude, longitude);
          final mapLocation = new Location(
              latitude: _location.latitude,
              longitude: _location.longitude,
              timestamp: DateTime.now());
        }
      }

      WidgetCommon.dismissLoading();
      setState(() {});
    } catch (e) {
      WidgetCommon.dismissLoading();
      setState(() {});
    }
  }

  void changeInfoCustomer(
      EmployeeTrackingModel mapTicketModel, int index, int length) async {
    currentNode =
        this._mapProvider.getListEmployeeTrackingModel.elementAt(index);
    setState(() {
      // checkTapMap = true;
    });
  }

  gotocenter() {
    _mapController?.animateCamera(CameraUpdate.newLatLng(_center!));
    // _mapController.showMarkerInfoWindow(MarkerId(centervymo));
  }

  firstDataCenter() async {
    if (this._mapProvider.lstEmployeeTrackingModel.length > 0) {
      await Future.delayed(Duration(milliseconds: 300));
      currentNode = this._mapProvider.lstEmployeeTrackingModel.elementAt(0);
    }
    await gotocenter();
    setState(() {});
  }

  firstData() async {
    if (this._mapProvider.lstEmployeeTrackingModel.length > 0) {
      await Future.delayed(Duration(milliseconds: 300));
      switchPosition(this._mapProvider.lstEmployeeTrackingModel.elementAt(0));
    }
  }

  void _onMapCreated(VietmapController controller) async {
    _mapController = controller;
    await Future.delayed(Duration(milliseconds: 300));
    await hanleAddressToGetMarker();
    await firstDataCenter();
  }

  void _onCameraMove(CameraPosition position) async {
    this._cameraPosition = position;
    //  _debouncer(() async {
    //    checkmove= false;
    //  });
    checkmove = false;
  }

  checkCenter(position) {
    if (position.latitude == _center?.latitude &&
        position.longitude == _center?.longitude) {
      return true;
    }
    return false;
  }

  void _onCameraIdle() async {
    if (Utils.checkIsNotNull(this._cameraPosition)) {
      if (!checkCenter(this._cameraPosition?.target)) {
        checkmove = true;
        _debouncer(() async {
          if (checkmove) {
            await setPosition(this._cameraPosition?.target);
            await hanleAddressToGetMarker();
            await firstData();
            await gotocenter();
          }
        });
      }
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await getPosition();
    setController(_radius.toString());
    title = S.of(context).radius + ' ' + _radius.toString() + ' km';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 58, 184, 62),
                  Color.fromARGB(255, 38, 134, 45),
                  Color.fromARGB(255, 6, 51, 9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          title: buildBarSearch(context),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () async {
                await dialogRadius();
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.center_focus_strong_rounded),
            //   onPressed: () async {
            //     await gotocenter();
            //   },
            // ),
          ],
        ),
        body: buildMap(context));
  }

  dynamic buildMap(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _mapFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              height: AppState.getHeightDevice(context),
              width: AppState.getWidthDevice(context),
              child: Center(
                child: WidgetCommon.buildCircleLoading(),
              ));
        }

        return Stack(children: [
          _center != null ? drawMap(context) : Container(),
          currentNode != null ? _buildContainer(context) : Container(),
        ]);
      },
    );
  }

  dialogRadius() {
    EasyDialog(
        cornerRadius: 15.0,
        fogOpacity: 0.1,
        width: 280,
        height: 180,
        contentPadding:
            EdgeInsets.only(top: 0.0), // Needed for the button design
        contentList: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: TextButton(
                  onPressed: () async {
                    await hanleAddressToGetMarker();
                    await firstDataCenter();
                    title = S.of(context).radius +
                        ' ' +
                        _radiusController.text +
                        ' km';
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).radius + ' (km)',
                    style: TextStyle(
                        color: AppColor.white, fontWeight: FontWeight.bold),
                    textScaleFactor: 1.3,
                  ))),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _radiusController,
                    textInputAction: TextInputAction.search,
                    autofocus: false,
                    style: TextStyle(color: AppColor.black),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: S.of(context).radius + ' km',
                      hintStyle: const TextStyle(color: Colors.black),
                      // border: InputBorder.none,
                    ),
                    // onChanged: onSearchChanged(),
                    // onSubmitted: (text) async {
                    //   await hanleAddressToGetMarker();
                    //   await firstDataCenter();
                    // },
                  ))),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
            child: TextButton(
              onPressed: () async {
                await hanleAddressToGetMarker();
                await firstDataCenter();
                title =
                    S.of(context).radius + ' ' + _radiusController.text + ' km';
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).btOk,
                style: TextStyle(color: AppColor.black),
                textScaleFactor: 1.3,
              ),
            ),
          ),
        ]).show(context);
  }

  Widget buildBarSearch(BuildContext context) {
    return Text(title);
  }

  Widget buildFilter(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: new Form(
            key: _formKey,
            onChanged: () {},
            child: Column(children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _radiusController,
                validator: (val) => Utils.isRequire(context, val ?? ''),
                onFieldSubmitted: (text) {
                  hanleAddressToGetMarker();
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).radius + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ])));
  }

  Widget drawMap(BuildContext context) {
    return Container(
        height: AppState.getHeightDevice(context) - 160,
        width: AppState.getWidthDevice(context),
        child: Stack(children: <Widget>[
          // GoogleMap(
          //     tiltGesturesEnabled: true,
          //     compassEnabled: true,
          //     scrollGesturesEnabled: true,
          //     zoomGesturesEnabled: true,
          //     zoomControlsEnabled: true,
          //     mapType: MapType.normal,
          //     markers: Set<Marker>.of(_markers),
          //     // myLocationEnabled: true,
          //     myLocationButtonEnabled: true,
          //     onMapCreated: _onMapCreated,
          //     onCameraIdle: _onCameraIdle,
          //     onCameraMove: _onCameraMove,
          //     initialCameraPosition: CameraPosition(
          //       target: _center,
          //       zoom: 12,
          //     )),
          // Positioned(
          //     top: 20,
          //     left: MediaQuery.of(context).size.width * 0.05,
          //     child: buildSearchMap(context))
        ]));
  }

  Widget _buildContainer(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 80.0,
        child: currentNode != null ? _boxes(currentNode) : Container(),
      ),
    );
  }

  _gotoLocation(title, list, item) async {
    final result = await showBarModalBottomSheet(
      expand: true,
      context: context,
      builder: (context) =>
          VietMapListTrackingPage(title: title, list: list, item: item),
    );
    if (result != null && result['action'] == true) {
      switchPosition(result['data']);
    }
  }

  Widget _boxes(EmployeeTrackingModel? detail) {
    return Container(
        width: AppState.getWidthDevice(context),
        color: Colors.white,
        child: Row(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(left: 7.0),
                child: InkWell(
                    onTap: () async {
                      switchPositionInfo(AppStateConfigConstant.INCREASE);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 30.0,
                    )),
              ),
            ),
            Flexible(
                //   child: GestureDetector(
                // onTap: () {
                //   _gotoLocation(S.of(context).List,
                //       this._mapProvider.lstEmployeeTrackingModel, detail);
                // },
                // child: _buildLeadingTile(detail, context),)
                child: InkWell(
              onTap: () {
                _gotoLocation(S.of(context).List,
                    this._mapProvider.lstEmployeeTrackingModel, detail);
              },
              child: _buildLeadingTile(detail, context),
            )),
            Center(
              child: Container(
                padding: EdgeInsets.only(right: 7.0),
                child: InkWell(
                    onTap: () async {
                      switchPositionInfo(AppStateConfigConstant.INCREASE);
                    },
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 30.0,
                    )),
              ),
            ),
          ],
        ));
  }

  Widget _buildLeadingTileDetail(
      EmployeeTrackingModel? detail, BuildContext context) {
    if (detail == null) {
      return Container();
    }
    if (detail.trackDate == null) {
      return Container();
    }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          detail?.tenantCode ?? '',
          style: TextStyle(fontSize: 12.0, color: Colors.black54),
        ),
        Text(
          Utils.getTimeFromDate(detail.trackDate) ?? '',
          style: TextStyle(fontSize: 12.0, color: Colors.black54),
        ),
        new SizedBox(height: 4.0),
      ],
    );
  }

  Widget _buildLeadingTile(EmployeeTrackingModel? detail, BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 7),
        ListTile(
          leading: CircleAvatar(
            child: Text(detail?.makerId![0] ?? '',
                style: TextStyle(color: AppColor.white)),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(
            detail?.makerId ?? '',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: _buildLeadingTileDetail(detail, context),
        ),
        Divider(
          height: 2.0,
        ),
      ],
    );
  }

  void switchPosition(EmployeeTrackingModel detail) {
    final location = detail.coordinates;
    final latitude = double.tryParse(location?.latitude?.toString() ?? '0.0');
    final longitude = double.tryParse(location?.longitude?.toString() ?? '0.0');
    
    if (latitude == null || longitude == null) return;
    
    final _location = LatLng(latitude, longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLng(_location));
    currentNode = detail;
    setState(() {});
  }


  switchPositionInfo(String type) {
    if (type == AppStateConfigConstant.DECREASE) {
      if (this.currentIndex == 0) {
        this.currentIndex =
            this._mapProvider.lstEmployeeTrackingModel.length - 1;
      } else {
        this.currentIndex = this.currentIndex - 1;
      }
    } else if (type == AppStateConfigConstant.INCREASE) {
      if (this.currentIndex ==
          this._mapProvider.lstEmployeeTrackingModel.length - 1) {
        this.currentIndex = 0;
      } else {
        this.currentIndex = this.currentIndex + 1;
      }
    }
    EmployeeTrackingModel map =
        this._mapProvider.lstEmployeeTrackingModel.elementAt(this.currentIndex);

    final location = map.coordinates;
    
    final latitude = double.tryParse(location?.latitude?.toString() ?? '0.0');
    final longitude = double.tryParse(location?.longitude?.toString() ?? '0.0');

    // _mapController.animateCamera(CameraUpdate.newLatLng(
    //     LatLng(_location.latitude, _location.longitude)));
     if (latitude != null && longitude != null) {
      final _location = LatLng(latitude, longitude);
      _mapController?.animateCamera(CameraUpdate.newLatLng(_location));
    }

    changeInfoCustomer(map, this.currentIndex,
        this._mapProvider.lstEmployeeTrackingModel.length);
  }

  @override
  void dispose() {
    WidgetCommon.dismissLoading();
    this._mapProvider.clearData();
    this.currentIndex = 0;
    currentIndex = 0;
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

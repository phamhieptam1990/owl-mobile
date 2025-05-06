import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/tickets/mapTicket.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/collections/checkin/allFeature.screen.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/debouncer.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import 'vietmap.provider.dart';
import 'package:athena/models/map/location.model.dart';

class VietMapScreen extends StatefulWidget {
  VietMapScreen({Key? key}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<VietMapScreen> with AfterLayoutMixin {
  final _mapService = new VietMapService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'map');
  final _mapProvider = getIt<VietMapProvider>();
  VietmapController? _mapController;
  CollectionService _collectionService = new CollectionService();
  bool isLoadMapComplete = false;
  LatLng? _center;
  // bool checkTapMap = true;
  List<Marker> _markers = <Marker>[];
  MapTicketModel? currentNode;
  // Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  int currentIndex = 0;
  Future _mapFuture = Future.delayed(Duration(milliseconds: 500), () => true);
  DateTime? selectedDate;
  TextEditingController _searchQueryController = new TextEditingController();
  final _debouncer = Debouncer();
  String lastKeywordSearch = '';
  bool isSearch = false;
  final _categoryProvider = new CategorySingeton();
  @override
  void initState() {
    super.initState();
    _searchQueryController.addListener(onSearchChanged);
  }

  Future<void> onSearchChanged() async {
    _debouncer(() async {
      String text = _searchQueryController.text.toString();
      if (text.length <= 2) {
        return;
      }
      if (lastKeywordSearch != text) {
        lastKeywordSearch = text;
        await updateSearchQuery(text, hideKeyBoard: false);
      }
    });
  }

 Future<void> handleFetchData() async {
  try {
    Response? response;

    if (isSearch) {
      response = await _mapService
          .searchPositionMap(_searchQueryController.text.toString());
    } else if (_mapProvider.typeSearch == MapConstant.HOME_SEARCH) {
      response = await _mapService.getPagingList(_mapProvider.getCurrentPage, '', {
        "hasCheckinInMonth": {
          "type": FilterType.EQUALS,
          "filter": FilterType.FALSE,
          "filterType": FilterType.TEXT
        }
      });
    } else if (_mapProvider.typeSearch == MapConstant.PLANNED) {
      if (selectedDate == null) {
        selectedDate = DateTime.now();
      }
      response = await _collectionService.getPagingPlannedDate(0, date: selectedDate);
    } else {
      // Default case to prevent response being potentially uninitialized
      response = await _mapService.getPagingList(_mapProvider.getCurrentPage, '', {});
    }

    if (Utils.checkRequestIsComplete(response)) {
      var lstData = Utils.handleRequestData2Level(response);
      for (var data in lstData) {
        MapTicketModel mapModel = MapTicketModel.fromJson(data);
        mapModel.location = Location(
            latitude: 0.0, longitude: 0.0, timestamp: DateTime.now());
        mapModel.customerData = {'mobilePhone': mapModel.cusMobilePhone};
        _mapProvider.getLstTicketModel.add(mapModel);
      }
    }
    if (_mapProvider.getLstTicketModel.isNotEmpty) {
      currentNode = _mapProvider.getLstTicketModel.elementAt(0);
    }
  } catch (e) {
    WidgetCommon.dismissLoading();
  }
}

  Future<void> getPosition() async {
      Position? position = await PermissionAppService.getCurrentPosition();
  
  if (position != null) {
    _center = LatLng(position.latitude, position.longitude);
    setState(() {});
  } else {
    // Default location if position is null
    _center = LatLng(10.762622, 106.660172); // Default to Ho Chi Minh City
    setState(() {});
  }
  }

  convertParams(lst) {
    String value = '';
    for (var i = 0; i < lst.length; i++) {
      if (Utils.checkIsNotNull(value)) {
        value = value + ',' + lst[i];
      } else
        value = value + lst[i];
    }
    return value;
  }

  Future<void> hanleAddressToGetMarker() async {
    if (!isSearch) {
      await Future.delayed(Duration(milliseconds: 300));
    }
    try {
      WidgetCommon.showLoading();
      await handleFetchData();
      String cusFullAddress = '';
      List<String> lstCustomerId = [];

      for (int index = 0;
          index < _mapProvider.getLstTicketModel.length;
          index++) {
        MapTicketModel map = _mapProvider.getLstTicketModel.elementAt(index);
        cusFullAddress = map.cusFullAddress ?? '';
        lstCustomerId.add(map.customerId.toString());
      }
      if (lstCustomerId.isNotEmpty) {
        String params = convertParams(lstCustomerId);
        Response resMap =
            await _collectionService.getLocationFromAddress(params);
        if (Utils.checkRequestIsComplete(resMap)) {
          var responseData = Utils.handleRequestData(resMap);
          if (Utils.checkIsNotNull(responseData)) {
            responseData.forEach((key, value) {
              for (int index = 0;
                  index < _mapProvider.getLstTicketModel.length;
                  index++) {
                if (_mapProvider.getLstTicketModel
                        .elementAt(index)
                        .customerId ==
                    key) {
                  if (Utils.isArray(value)) {
                    final locationTemp = value[0];
                    if (Utils.checkIsNotNull(locationTemp['latitude']) &&
                        Utils.checkIsNotNull(locationTemp['longitude'])) {
                      double latitude = double.parse(locationTemp['latitude']);
                      double longitude =
                          double.parse(locationTemp['longitude']);
                      LatLng _location = new LatLng(latitude, longitude);
                      if (Utils.checkIsNotNull(_location)) {
                        Location location = new Location(
                            latitude: _location.latitude,
                            longitude: _location.longitude,
                            timestamp: DateTime.now());
                        _mapProvider.getLstTicketModel
                            .elementAt(index)
                            .location = location;
                        MapTicketModel item =
                            _mapProvider.getLstTicketModel.elementAt(index);
                        _markers.add(createMaker(item, index));
                        // _markers.add(Marker(
                        //     onTap: () async {
                        //       changeInfoCustomer(
                        //           _mapProvider.getLstTicketModel
                        //               .elementAt(index),
                        //           index,
                        //           _markers.length);
                        //     },
                        //     markerId: MarkerId(_mapProvider.getLstTicketModel
                        //         .elementAt(index)
                        //         .id
                        //         .toString()),
                        //     position: new LatLng(
                        //         location.latitude, location.longitude),
                        //     infoWindow: InfoWindow(
                        //         title: _mapProvider.getLstTicketModel
                        //             .elementAt(index)
                        //             .issueName)));
                      }
                    }
                  }
                  // break;
                }
              }
            });
          }
        }
        // Location location = new Location(
        //     latitude: 10.80593217,
        //     longitude: 106.60187025,
        //     timestamp: DateTime.now());
        // _mapProvider.getLstTicketModel.elementAt(0).location = location;
        // _markers
        //     .add(createMaker(_mapProvider.getLstTicketModel.elementAt(0), 0));
        // _mapController.animateCamera(CameraUpdate.newLatLng(
        //     LatLng(location.latitude, location.longitude)));
      }
      WidgetCommon.dismissLoading();
    } catch (e) {
      WidgetCommon.dismissLoading();
    } finally {
      if (_mapProvider.getLstTicketModel.length > 0 && isSearch) {
        await Future.delayed(Duration(milliseconds: 300));
        await _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(
            _mapProvider.getLstTicketModel[0].location?.latitude ?? 0.0,
            _mapProvider.getLstTicketModel[0].location?.longitude ?? 0.0)));
      }
      setState(() {});

      await this._categoryProvider.initAllCateogyData();
    }
  }

  createMaker(MapTicketModel item, int index) {
    return Marker(
        child: InkWell(
            child: Container(
              width: 33,
              height: 33,
              child: Icon(Icons.location_on, color: Colors.red, size: 33),
            ),
            onTap: () async {
              changeInfoCustomer(
                  _mapProvider.getLstTicketModel.elementAt(index),
                  index,
                  _markers.length);
            }),
        latLng: LatLng(
            _mapProvider.getLstTicketModel.elementAt(index).location?.latitude ??
              0.0,
            _mapProvider.getLstTicketModel
                .elementAt(index)
                .location
                ?.longitude ??
              0.0),);
  }

  void changeInfoCustomer(
      MapTicketModel mapTicketModel, int index, int length) async {
    currentNode = _mapProvider.getLstTicketModel.elementAt(index);
    setState(() {});
  }

  void _onMapCreated(VietmapController controller) async {
    _mapController = controller;
    await Future.delayed(Duration(milliseconds: 300));
    await hanleAddressToGetMarker();
  }

  void _onCameraIdle() async {}

  @override
  void afterFirstLayout(BuildContext context) async {
    await getPosition();
  }

  @override
  Widget build(BuildContext context) {
 // Fix null safety issue with ModalRoute arguments
  final routeArgs = ModalRoute.of(context)?.settings.arguments;
  selectedDate = routeArgs != null ? routeArgs as DateTime : DateTime.now();
    return Scaffold(
        appBar: isSearch
            ? AppBar(
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
                title: TextField(
                  controller: _searchQueryController,
                  textInputAction: TextInputAction.search,
                  autofocus: false,
                  style: TextStyle(color: AppColor.white),
                  decoration: const InputDecoration(
                    hintText:
                        "Tìm kiếm theo tên, email, số điện thoại hoặc địa chỉ",
                    hintStyle: const TextStyle(color: Colors.white60),
                    // border: InputBorder.none,
                  ),
                  // onChanged: onSearchChanged(),
                  onSubmitted: updateSearchQuery,
                ),
                actions: [
                  InkWell(
                    onTap: () async {
                      isSearch = !isSearch;
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {});
                    },
                    child: Container(
                      width: 40.0,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.close),
                    ),
                  )
                ],
              )
            : AppBarCommon(
                lstWidget: [
                  InkWell(
                    onTap: () async {
                      isSearch = !isSearch;
                      setState(() {});
                    },
                    child: Container(
                      width: 40.0,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.search),
                    ),
                  )
                ],
                title: S.of(context).seeMap,
              ),
        // appBar: AppBar(
        //   title: TextField(
        //     controller: _searchQueryController,
        //     textInputAction: TextInputAction.search,
        //     autofocus: false,
        //     style: TextStyle(color: AppColor.white),
        //     decoration: const InputDecoration(
        //       hintText: "Tìm kiếm theo tên, email, số điện thoại hoặc địa chỉ",
        //       hintStyle: const TextStyle(color: Colors.white60),
        //       // border: InputBorder.none,
        //     ),
        //     // onChanged: onSearchChanged(),
        //     onSubmitted: updateSearchQuery,
        //   ),
        // ),
        body: buildMap(context));
  }

  Future<void> updateSearchQuery(String newQuery,
      {bool hideKeyBoard = true}) async {
    if (hideKeyBoard) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
    // setState(() {
    //   _isSearching = true;
    //   _enablePullUp = true;
    //   if (isFirstEnter) {
    //     isFirstEnter = false;
    //   }
    // });
    _mapProvider.lstTicketModel = [];
    _mapProvider.keyword = newQuery;
    _mapProvider.currentPage = 1;
    _markers = [];
    await hanleAddressToGetMarker();
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
          drawMap(context),
          (currentNode != null) ? _buildContainer(context) : Container()
        ]);
        // return drawMap(context);
      },
    );
  }

  Widget drawMap(BuildContext context) {
    return Stack(children: [
      VietmapGL(
        styleString:
            "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=cb5c36e2396bc1f4fdb46952cc925f9548d5f7bd59ae8d40",
        compassEnabled: true,
        trackCameraPosition: true,
        tiltGesturesEnabled: true,
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        onCameraIdle: _onCameraIdle,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(_center?.latitude ?? 0.0, _center?.longitude ?? 0.0), zoom: 10),
      ),
      _mapController == null
          ? SizedBox.shrink()
          : MarkerLayer(
              ignorePointer: true,
              mapController: _mapController!,
              markers: _markers),
    ])
        //  GoogleMap(
        //     tiltGesturesEnabled: true,
        //     compassEnabled: true,
        //     scrollGesturesEnabled: true,
        //     zoomGesturesEnabled: true,
        //     mapType: MapType.normal,
        //     markers: Set<Marker>.of(_markers),
        //     myLocationEnabled: true,
        //     myLocationButtonEnabled: true,
        //     onMapCreated: _onMapCreated,
        //     onCameraIdle: _onCameraIdle,
        //     initialCameraPosition: CameraPosition(
        //       target: _center,
        //       zoom: 12,
        //     ))

        ;
  }

  Widget _buildContainer(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 130.0,
        child: _boxes(currentNode),
      ),
    );
  }

  Widget _boxes(MapTicketModel? detail) {
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
              child: _buildLeadingTile(detail, context),
            ),
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

  Widget _buildLeadingTileDetail(MapTicketModel? detail, BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          (Utils.retunDataStr(detail?.actionGroupCode).isNotEmpty)
              ? _collectionService.convertActionGroupName(
                  detail?.actionGroupCode ?? '', detail?.actionGroupName ?? '', context)
              : _collectionService.convertStatusCode(
                  detail?.statusCode ?? '', context),
          style: TextStyle(fontSize: 12.0, color: Colors.black54),
        ),
        new SizedBox(height: 4.0),
      ],
    );
  }

  handleSmsCallLog(action, ticketModel, type) async {}

  Widget _buildLeadingTile(MapTicketModel? detail, BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            child: Text(detail?.issueName![0] ??'',
                style: TextStyle(color: AppColor.white)),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(
            detail?.issueName ?? '',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: _buildLeadingTileDetail(detail, context),
        ),
        Divider(
          height: 1.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async => {
                handleSmsCallLog(
                    _mapService.actionPhone(
                        currentNode!, ActionPhone.CALL, context),
                    currentNode,
                    ActionPhone.CALL)
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    color: _collectionService.colorDisableAction(
                        currentNode, context),
                  ),
                  Text(S.of(context).phone,
                      style: TextStyle(color: Colors.black))
                ],
              ),
            ),
            TextButton(
              onPressed: () async => {
                await _mapService.openGoogleMaps(
                  detail?.cusFullAddress ?? '',
                  destinationLatitude: detail?.location?.latitude,
                  destinationLongitude: detail?.location?.longitude,
                  sourceLatitude: _center?.latitude,
                  sourceLongitude: _center?.longitude,
                )
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.near_me,
                    color: _collectionService.colorDisableAction(
                        currentNode, context),
                  ),
                  Text(
                    S.of(context).direction,
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () async =>
                  {_navigateAndDisplaySelection(context, detail)},
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.receipt,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text('Cập nhật', style: TextStyle(color: Colors.black))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _navigateAndDisplaySelection(
      BuildContext context, MapTicketModel? ticketModel) async {
    try {
      Map<String, dynamic> abc = currentNode?.toJson() ?? {};
      TicketModel ticketModel = TicketModel.fromJson(abc);
      await _categoryProvider.initAllCateogyData();
      final result = await NavigationService.instance.navigateToRoute(
        MaterialPageRoute(
            builder: (context) => CheckInAllFeatureScreen(ticket: ticketModel)),
      );

      if (result != null) {
        String actionGroupName = result['actionGroupName'];
        String actionGroupCode = result['actionGroupCode'];
        currentNode?.actionGroupName = actionGroupName;
        currentNode?.actionGroupCode = actionGroupCode;
        ticketModel.actionGroupName = actionGroupName;
        ticketModel.actionGroupCode = actionGroupCode;
        for (int index = 0;
            index < _mapProvider.getLstTicketModel.length;
            index++) {
          if (_mapProvider.getLstTicketModel[index].id == currentNode?.id) {
            _mapProvider.getLstTicketModel[index].actionGroupName =
                actionGroupName;
            _mapProvider.getLstTicketModel[index].actionGroupCode =
                actionGroupCode;
            break;
          }
        }
        setState(() {});
        WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_sucess,
            backgroundColor: AppColor.blue);
      }
    } catch (e) {}
  }

  switchPositionInfo(String type) {
    if (type == AppStateConfigConstant.DECREASE) {
      if (currentIndex == 0) {
        currentIndex = this._mapProvider.getLstTicketModel.length - 1;
      } else {
        currentIndex = currentIndex - 1;
      }
    } else if (type == AppStateConfigConstant.INCREASE) {
      if (currentIndex == this._mapProvider.getLstTicketModel.length - 1) {
        currentIndex = 0;
      } else {
        currentIndex = currentIndex + 1;
      }
    }
    MapTicketModel map =
        this._mapProvider.getLstTicketModel.elementAt(currentIndex);
    _mapController?.animateCamera(CameraUpdate.newLatLng(
        LatLng(map.location?.latitude ?? 0.0, map.location?.longitude ?? 0.0)));

    // _mapController
    //     .
    //     _mapController.showMarkerInfoWindow(MarkerId(
    //         _mapProvider.getLstTicketModel.elementAt(currentIndex).id.toString()));
    changeInfoCustomer(
        map, currentIndex, this._mapProvider.getLstTicketModel.length);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetCommon.dismissLoading();
    _mapProvider.clearData();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

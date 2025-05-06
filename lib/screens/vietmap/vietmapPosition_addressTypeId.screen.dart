import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.provider.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:athena/models/map/location.model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/tickets/mapTicket.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/call_sms_log/call_sms_log.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/getit.dart';
import 'package:athena/utils/utils.dart';

class VietMapScreenAddressTypeIdPosition extends StatefulWidget {
  VietMapScreenAddressTypeIdPosition({Key? key}) : super(key: key);
  @override
  _MapScreenAddressTypeIdPositionState createState() =>
      _MapScreenAddressTypeIdPositionState();
}

class _MapScreenAddressTypeIdPositionState
    extends State<VietMapScreenAddressTypeIdPosition> with AfterLayoutMixin {
  final _mapService = new VietMapService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'mapPositionTypeId');
  VietmapController? mapController;
  CollectionService _collectionService = new CollectionService();
  final _mapProvider = getIt<VietMapProvider>();
  LatLng? _center;
  Future _mapFuture = Future.delayed(Duration(milliseconds: 500), () => true);

  final List<Marker> _markers = <Marker>[];
  MapTicketModel? currentNode;
  // TicketModel? ticketModel;
  // Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();
  @override
  void initState() {
    super.initState();
  }

  void hanleAddressToGetMarker() async {
    try {
      String lstCustomerId = (currentNode?.customerId ?? '').toString();
      final addressTypeId = currentNode?.addressTypeId;
      var checkExit = false;
      Response resMap = await _collectionService.getLocationFromAddressTypeId(
          lstCustomerId, addressTypeId);
      if (Utils.checkRequestIsComplete(resMap)) {
        var responseData = Utils.handleRequestData(resMap);
        if (Utils.checkIsNotNull(responseData)) {
          responseData.forEach((key, value) {
            if (currentNode?.customerId == key) {
              if (Utils.isArray(value)) {
                final locationTemp = value[0];
                if (Utils.checkIsNotNull(locationTemp['latitude']) &&
                    Utils.checkIsNotNull(locationTemp['longitude'])) {
                  double latitude = double.parse(locationTemp['latitude']);
                  double longitude = double.parse(locationTemp['longitude']);
                  LatLng _location = new LatLng(latitude, longitude);
                  if (Utils.checkIsNotNull(_location)) {
                    Location location = new Location(
                        latitude: _location.latitude,
                        longitude: _location.longitude,
                        timestamp: DateTime.now());
                    currentNode?.location = location;
                    checkExit = true;
                    _markers.add(createMaker(currentNode?.location));
                    // _markers.add(Marker(
                    //     onTap: () async {
                    //       changeInfoCustomer(currentNode, 0, _markers.length);
                    //     },
                    //     markerId: MarkerId(currentNode.id.toString()),
                    //     position:
                    //         new LatLng(location.latitude, location.longitude),
                    //     infoWindow: InfoWindow(title: currentNode.issueName)));
                    // setState(() {
                    mapController?.animateCamera(CameraUpdate.newLatLng(
                        LatLng(location.latitude, location.longitude)));
                    // });
                  }
                }
              }
            }
          });
        } else {
        
        }
      }
        if (checkExit == false) {
        if (addressTypeId == ADDRESS_TYPE_ID.companyAddress) {
          WidgetCommon.showSnackbar(
              _scaffoldKey, 'Hợp đồng không có địa chỉ công ty');
        } else if (addressTypeId == ADDRESS_TYPE_ID.permanentAddress) {
          WidgetCommon.showSnackbar(
              _scaffoldKey, 'Hợp đồng không có địa chỉ thường trú');
        } else if (addressTypeId == ADDRESS_TYPE_ID.cusFullAddress) {
          WidgetCommon.showSnackbar(
              _scaffoldKey, 'Hợp đồng không có địa chỉ tạm trú');
        }
      }
    } catch (e) {
      setState(() {});
    } finally {
      
      setState(() {});
      //

      // await mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
      //     currentNode.location.latitude, currentNode.location.longitude)));
    }
  }

  createMaker(location) {
    return Marker(
        child: InkWell(
            child: Container(
              width: 33,
              height: 33,
              child: Icon(Icons.location_on, color: Colors.red, size: 33),
            ),
            onTap: () async {
              setState(() {});
            }),
        latLng: LatLng(location.latitude, location.longitude));
  }

  void changeInfoCustomer(
      MapTicketModel mapTicketModel, int index, int length) async {
    setState(() {});
  }

  void _onMapCreated(VietmapController controller) async {
    // setState(() {
    mapController = controller;
    // });
    await Future.delayed(Duration(milliseconds: 300));
    hanleAddressToGetMarker();
  }

  @override
  void afterFirstLayout(BuildContext context) async {}

  Widget infomation(BuildContext context) {
    return Container(
      child: Text(S.of(context).APP_NAME),
    );
  }

  @override
  Widget build(BuildContext context) {
  
   dynamic ticketModel;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is MapTicketModel) {
      ticketModel = args as MapTicketModel;
    } else if (args is TicketModel) {
      ticketModel = args as TicketModel;
    }
    if (currentNode == null) {
      currentNode = new MapTicketModel(
          customerId: ticketModel?.customerId,
          issueName: ticketModel?.issueName,
          actionGroupName: ticketModel?.actionGroupName,
          statusCode: ticketModel?.statusCode,
          location: new Location(
              latitude: 0.0, longitude: 0.0, timestamp: DateTime.now()),
          cusFullAddress: ticketModel?.cusFullAddress,
          permanentAddress: ticketModel?.permanentAddress,
          companyAddress: ticketModel?.companyAddress,
          addressTypeId: ticketModel?.addressTypeId,
          customerData: ticketModel?.customerData);
    }
    if (_center == null) {
      _center = _mapProvider.centerPosition;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarCommon(
        lstWidget: [],
        title: S.of(context).seeMap,
      ),
      body: buildMap(context),
    );
  }

  void _onCameraIdle() async {}
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
            target: LatLng(_center?.latitude ?? 0.0, _center?.longitude ??0.0), zoom: 10),
      ),
      mapController == null
          ? SizedBox.shrink()
          : MarkerLayer(
              ignorePointer: true,
              mapController: mapController!,
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
    // return GestureDetector(
    //     onTap: () {
    //       // _gotoLocation(lat,long);
    //     },
    //     child: Container(
    //       width: AppState.getWidthDevice(context),
    //       child: Container(
    //         color: Colors.white,
    //         child: _buildLeadingTile(detail, context),
    //       ),
    //     ));
    return Container(
      width: AppState.getWidthDevice(context),
      child: Container(
        color: Colors.white,
        child: _buildLeadingTile(detail, context),
      ),
    );
  }

  Widget _buildLeadingTileDetail(MapTicketModel? detail, BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          (detail?.actionGroupName != null)
              ? detail?.actionGroupName
              : _collectionService.convertStatusCode(
                  detail?.statusCode ?? '', context),
          style: TextStyle(fontSize: 12.0, color: Colors.black54),
        ),
        new SizedBox(height: 4.0),
      ],
    );
  }

  handleSmsCallLog(action, ticketModel, type) async {
    var smsFrom = DateTime.now();
    var callFrom = DateTime.now();
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallSmsLog(
                  type: type,
                  action: action,
                  smsFrom: smsFrom,
                  callFrom: callFrom,
                  ticketModel: ticketModel,
                  phone: '',
                )));

    if (result == true) {
      // await getTicketHistory(isSetTate: true);
    }
  }

  Widget _buildLeadingTile(MapTicketModel? detail, BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            child: Text(detail?.issueName![0] ?? '',
                style: TextStyle(color: AppColor.white)),
            backgroundColor: AppColor.primary,
          ),
          title: Text(detail?.issueName ?? ''),
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
              onPressed: () async {
                var address = detail?.cusFullAddress ?? '';
                if (detail?.addressTypeId == ADDRESS_TYPE_ID.companyAddress) {
                  address = detail?.companyAddress ?? '';
                } else if (detail?.addressTypeId ==
                    ADDRESS_TYPE_ID.permanentAddress) {
                  address = detail?.permanentAddress ?? '';
                }
                await _mapService.openGoogleMaps(
                  address,
                  destinationLatitude: detail?.location?.latitude,
                  destinationLongitude: detail?.location?.longitude,
                  sourceLatitude: _center?.latitude,
                  sourceLongitude: _center?.longitude,
                );
              },
              // onLongPress: () async => {await _getPolyline()},
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.near_me,
                    color: _collectionService.colorDisableAction(
                        currentNode, context),
                  ),
                  Text(S.of(context).direction,
                      style: TextStyle(color: Colors.black))
                ],
              ),
            ),
            TextButton(
              onPressed: () async => {
                handleSmsCallLog(
                    _mapService.actionPhone(
                        currentNode!, ActionPhone.SMS, context),
                    currentNode,
                    ActionPhone.SMS)
                // _mapService.actionPhone(currentNode, ActionPhone.SMS, context)
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.sms,
                    color: _collectionService.colorDisableAction(
                        currentNode, context),
                  ),
                  Text(S.of(context).SMS, style: TextStyle(color: Colors.black))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // _getPolyline() async {
  //   WidgetCommon.showLoading();
  //   LatLng destination =
  //       LatLng(currentNode.location.latitude, currentNode.location.longitude);
  //   String route = await _mapService.getRouteCoordinates(_center, destination);
  //   createRoute(route);
  // }

  // final Set<Polyline> _polyLines = {};
  // Set<Polyline> get polyLines => _polyLines;

  // void createRoute(String encondedPoly) {
  //   if (encondedPoly == '') {
  //     WidgetCommon.dismissLoading();
  //     return;
  //   }
  //   _polyLines.add(Polyline(
  //       polylineId: PolylineId(currentNode.issueName.toString()),
  //       width: 4,
  //       points:
  //           _mapService.convertToLatLng(_mapService.decodePoly(encondedPoly)),
  //       color: Colors.red));
  //   WidgetCommon.dismissLoading();
  //   setState(() {});
  // }

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
      },
    );
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

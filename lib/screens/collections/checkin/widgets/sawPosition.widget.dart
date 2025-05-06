import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/tickets/mapTicket.model.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';

class SawPositionCheckin extends StatefulWidget {
  final LatLng? position;
  SawPositionCheckin({Key? key, this.position}) : super(key: key);
  @override
  _SawPositionCheckinState createState() => _SawPositionCheckinState();
}

class _SawPositionCheckinState extends State<SawPositionCheckin>
    with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'sawMapPosition');
  Completer<VietmapController> mapController = Completer();
  Future _mapFuture = Future.delayed(Duration(milliseconds: 500), () => true);
  final List<Marker> _markers = <Marker>[];
  @override
  void initState() {
    super.initState();
  }

  void hanleAddressToGetMarker() async {
    try {
      // _markers.add(Marker(
      //   onTap: () async {},
      //   markerId: MarkerId(DateTime.now().toString()),
      //   position:
      //       new LatLng(widget.position.latitude, widget.position.longitude),
      //   // infoWindow: InfoWindow(title: currentNode.issueName)
      // ));
    } catch (e) {
      setState(() {});
    } finally {
      setState(() {});
    }
  }

  void changeInfoCustomer(
      MapTicketModel mapTicketModel, int index, int length) async {
    setState(() {});
  }

  void _onMapCreated(VietmapController controller) {
    mapController.complete(controller);
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    hanleAddressToGetMarker();
  }

  Widget infomation(BuildContext context) {
    return Container(
      child: Text(S.of(context).APP_NAME),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarCommon(
        lstWidget: [],
        title: 'Xem vị trí check in',
      ),
      body: buildMap(context),
    );
  }

  Widget drawMap(BuildContext context) {
    return Container(
        height: AppState.getHeightDevice(context),
        width: AppState.getWidthDevice(context),
        child: Container()
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
        //     initialCameraPosition: CameraPosition(
        //       target: widget.position,
        //       zoom: 12,
        //     ))
        );
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

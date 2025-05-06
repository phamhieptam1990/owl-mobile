import 'dart:convert';
import 'dart:io';

import 'package:athena/screens/vietmap/vietmap.provider.dart';
import 'package:athena/utils/storage/storage_helper.dart';
// import 'package:device_apps/device_apps.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/tickets/mapTicket.model.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/search/search.service.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';

import '../../utils/log/crashlystic_services.dart';

class VietMapService {
  final SearchService _searchService = SearchService();
  final _mapProvider = getIt<VietMapProvider>();
  final _homeProvider = getIt<HomeProvider>();
  
  Future<Response> getPagingList(
      int currentPage, String? keyword, dynamic statusFiler) async {
    if (keyword == "Search query" || keyword == "") {
      keyword = null;
    }
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);
    // var dataJson = 'request=' +
    //     Uri.encodeComponent('{"startRow":' +
    //         offsetCurrent.toString() +
    //         ',"endRow":' +
    //         (offsetCurrent + lengthCurrent).toString() +
    //         ',"rowGroupCols":[],"valueCols":[],"pivotCols":[],"pivotMode":false,"groupKeys":[],"filterModel":{"recordStatus": {"type": "${FilterType.EQUALS}","filter": "O","filterType": "${FilterType.TEXT}"}},"sortModel":[{"colId":"createDate","sort":"desc"}]}');
    var dataJson = {
      "startRow": offsetCurrent.toString(),
      "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1).toString(),
      "filterModel": {},
      "sortModel": [
        {"colId": "createDate", "sort": "desc"}
      ]
    };

    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.PIVOT_PAGING,
        body: dataJson, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> handleRequestVmap(String url) async {
    return HttpHelper.getWithoutToken(url,
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON);
  }

  Future<String> getAddressFromLongLatVMap(
      double lat, double long, BuildContext context) async {
    try {
      if (MyConnectivity.instance.isOffline) {
        return S.of(context).addressCantGetWhenOffline;
      }
      String mapType = '';
      String typeAddress = '';

      // String mapType = MAP.VIETMAP;
      // String typeAddress = 'address,locality';
      // if (Utils.checkIsNotNull(_homeProvider.appDataConfig)) {
      //   if (_homeProvider.appDataConfig['useMapConfig'] == true) {
      //     mapType = '';
      //     typeAddress = '';
      //   }
      // }
      String companyCode =
          await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE) ??
              APP_CONFIG.COMPANY_CODE;
      final input = {
        "longitude": long,
        "latitude": lat,
        "layers": typeAddress,
        "region": "vn",
        "companyCode": companyCode,
        "appCode": APP_CONFIG.APP_CODE,
        "mapType": mapType
      };

      Response response = await this.reverseMap(input);
      // if (IS_PRODUCTION_APP) {
      return handleReponseVmap(response, MAP.ADDRESS);
      // } else {
      //   return Utils.checkIsNotNull(response?.data[0]['display'])
      //       ? response?.data[0]['display']
      //       : 'Default Location';
      // }
      // handle google;
      // String label = await this.getAddressFromLongLat(lat, long, context);
      // return label;
    } catch (e) {
      // handle google;
      // String label = await this.getAddressFromLongLat(lat, long, context);
      // return label;
      return '';
    }
  }

  Future<Response> reverseMap(dataJson) async {
    // if (IS_PRODUCTION_APP) {
    return HttpHelper.postJSON(MCR_FEA_URL.REVERSE_MAP,
        body: dataJson,
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
    // }
    // var dataSubmit = {
    //   'longitude': dataJson['input']['longitude'],
    //   'latitude': dataJson['input']['latitude'],
    // };

    // LatLng latLng =
    //     LatLng(dataJson['input']['latitude'], dataJson['input']['longitude']);

    // final _uri = Uri(
    //     scheme: 'https',
    //     host: 'maps.vietmap.vn',
    //     path: '/api/reverse/v2',
    //     queryParameters: {
    //       // 'region': 'vn',
    //       // 'latlng': '${latLng.latitude}, ${latLng.longitude}',
    //       'lng': '${latLng.longitude}',
    //       'lat': '${latLng.latitude}',
    //       'apikey': APP_CONFIG.VIETMAP_KEY_UAT
    //     });
    // return Dio().getUri(_uri);
  }

  Future<Response> searchMap(dataJson) async {
    return HttpHelper.post(MCR_FEA_URL.SEARCH_MAP,
        body: dataJson,
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }

  handleDataVmap(var dataFinal, String type) {
    // final code = dataFinal['code'];
    final dataFinalTemp = dataFinal;
    if (Utils.checkIsNotNull(dataFinalTemp[0])) {
      if (type == MAP.ADDRESS) {
        if (Utils.checkIsNotNull(dataFinalTemp[0]['display'])) {
          return dataFinalTemp[0]['display'];
        } else {
          return dataFinalTemp[0]['address'];
        }
      } else if (type == MAP.LATLONG) {
        return new LatLng(dataFinalTemp[0]['lat'], dataFinalTemp[0]['lng']);
      }
      // final features = dataFinalTemp['features'];
      // if (Utils.isArray(features)) {
      //   if (type == MAP.ADDRESS) {
      //     final properties = features[0]['properties'];
      //     if (Utils.checkIsNotNull(properties)) {
      //       return properties['label'];
      //     }
      //   } else if (type == MAP.LATLONG) {
      //     final geometry = features[0]['geometry'];
      //     if (Utils.checkIsNotNull(geometry)) {
      //       final coordinates = geometry['coordinates'];
      //       if (Utils.isArray(coordinates)) {
      //         return new LatLng(coordinates[1], coordinates[0]);
      //       }
      //     }
      //   }
      // }
    }
    return '';
  }

  handleReponseVmap(var response, String type) {
    try {
      if (Utils.checkIsNotNull(response)) {
        if (Utils.checkIsNotNull(response.data) &&
            Utils.checkIsNotNull(response.data['data'])) {
          final data = response.data['data'];
          if (Utils.checkIsNotNull(data)) {
            if (data['mapType'] == 'vietmap' &&
                Utils.checkIsNotNull(data['data'])) {
              return handleDataVmap(data['data'], type);
            } else {
              if (type == MAP.ADDRESS) {
                final dataFinal = data['data'];
                if (Utils.checkIsNotNull(dataFinal)) {
                  final status = dataFinal['status'];
                  final results = dataFinal['results'];
                  if (status == 'OK' && Utils.isArray(results)) {
                    return results[0]["formatted_address"];
                  }
                }
              } else if (type == MAP.LATLONG) {
                final dataFinal = data['data'];
                if (Utils.checkIsNotNull(dataFinal)) {
                  final status = dataFinal['status'];
                  final results = dataFinal['results'];
                  if (status == 'OK' && Utils.isArray(results)) {
                    var geometry = results[0]["geometry"];
                    if (Utils.checkIsNotNull(geometry)) {
                      var location = geometry['location'];
                      if (Utils.checkIsNotNull(location)) {
                        return new LatLng(location['lat'], location['lng']);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future getLatLngFromAddressVMap(String address, BuildContext context) async {
    try {
      if (MyConnectivity.instance.isOffline) {
        return S.of(context).addressCantGetWhenOffline;
      }
      String url = '';
      String mapType = MAP.GOOGLEMAP;
      if (Utils.checkIsNotNull(_homeProvider.appDataConfig)) {
        if (_homeProvider.appDataConfig['useGoogleMap'] == false) {
          mapType = MAP.VIETMAP;
        }
      }
      String companyCode =
          await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE) ??
              APP_CONFIG.COMPANY_CODE;
      final dataJSON = {
        "text": address,
        "region": "vn",
        "categories": "",
        "companyCode": companyCode,
        "appCode": APP_CONFIG.APP_CODE,
        "mapType": mapType
      };
      Response response =
          await this.searchMap("input=" + Utils.encodeRequestJson(dataJSON));
      return handleReponseVmap(response, MAP.LATLONG);
      // Response response = await this.handleRequestVmap(url);
      // String label = handleReponseVmap(response, MAP.ADDRESS);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getAddressFromLongLat(
      double lat, double long, BuildContext context) async {
    try {
      if (MyConnectivity.instance.isOffline) {
        return S.of(context).addressCantGetWhenOffline;
      }
      String googleKey = '';
      String url =
          "https://maps.googleapis.com/maps/api/geocode/json?region=${APP_CONFIG.GOOGLE_MAP_REGION}&latlng=$lat,$long&key=$googleKey";
      Uri myUri = Uri.parse(url);
      http.Response response = await http.get(myUri);
      Map values = jsonDecode(response.body);
      if (values['status'] == "OK") {
        if (Utils.isArray(values["results"])) {
          return values["results"][0]["formatted_address"];
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future getLatLngFromAddress(String address, BuildContext context) async {
    try {
      if (MyConnectivity.instance.isOffline) {
        return S.of(context).addressCantGetWhenOffline;
      }
      String googleKey = '';
      String url =
          "https://maps.googleapis.com/maps/api/geocode/json?region=${APP_CONFIG.GOOGLE_MAP_REGION}&address=$address&key=$googleKey";
      Uri myUri = Uri.parse(url);
      http.Response response = await http.get(myUri);
      Map values = jsonDecode(response.body);
      if (values['status'] == "OK") {
        if (Utils.isArray(values["results"])) {
          var geometry = values["results"][0]["geometry"];
          if (Utils.checkIsNotNull(geometry)) {
            var location = geometry['location'];
            if (Utils.checkIsNotNull(location)) {
              return new LatLng(location['lat'], location['lng']);
            }
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  actionPhone(MapTicketModel item, String type, BuildContext context) async {
    if (type == ActionPhone.DIRECTION) {
      // Utils.pushName(null, RouteList.MAP_SCREEN, params: item);
      if (APP_CONFIG.enableVietMap) {
        Utils.pushName(context, RouteList.VIETMAP_SCREEN, params: item);
      } else {}
      // Utils.pushName(null, RouteList.MAP_SCREEN, params: item);
    } else if (type == ActionPhone.EMAIL) {
      String email = item.customerData['email'] ?? '';
      if (email == '') {
        return WidgetCommon.generateDialogOKGet(
            content: S.of(context).customerNoEmail);
      }
      Utils.actionPhone(email, type);
    } else {
      String phone =
          item.cusMobilePhone ?? item.customerData["cellPhone"] ?? "";
      if (phone == '') {
        phone = item.customerData["cellPhone"];
        return WidgetCommon.generateDialogOKGet(
            content: S.of(context).customerNoPhone);
      }
      Utils.actionPhone(phone, type);
    }
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    List<double> lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }

  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  Future<Response> getEmployeeHirache(int offset) async {
    return HttpHelper.get(MCR_US_PROFILE_SERVICE_URL.SEARCH_EMPLOYEE +
        'numOfResult=1000&offset=$offset');
  }

  Future<Response> getListGpsUserCurrent(String dataJson) async {
    return HttpHelper.postForm(MCR_GCL_URL.GET_LIST_GPS_USER_CURRENT,
        body: dataJson, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }


Future<void> openGoogleMaps(
  String cusFullAddress, {
  double? sourceLatitude,
  double? sourceLongitude,
  double? destinationLatitude,
  double? destinationLongitude,
}) async {
  if (!Utils.checkIsNotNull(cusFullAddress) || cusFullAddress == 'null') {
    return WidgetCommon.generateDialogOKGet(content: 'Không tìm thấy địa chỉ.');
  }

  try {
    final encodedAddress = Uri.encodeComponent(cusFullAddress);

    if (Platform.isAndroid) {
      final googleMapsUrl = 'geo:0,0?q=$encodedAddress';

      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication);
      } else {
        // fallback to Play Store
        final fallbackUrl =
            'https://play.google.com/store/apps/details?id=com.google.android.apps.maps';
        return WidgetCommon.generateDialogOKCancelGet(
          'Vui lòng cài đặt Google Maps để sử dụng tính năng này.',
          callbackOK: () async {
            await launchUrl(Uri.parse(fallbackUrl),
                mode: LaunchMode.externalApplication);
          },
        );
      }
    } else if (Platform.isIOS) {
      String saddr = '${sourceLatitude ?? ""},${sourceLongitude ?? ""}';
      final googleMapsUrl =
          'comgooglemaps://?saddr=$saddr&daddr=$encodedAddress&directionsmode=driving';
      final webFallbackUrl =
          'https://maps.apple.com/?saddr=$saddr&daddr=$encodedAddress&dirflg=d';

      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(Uri.parse(webFallbackUrl))) {
        await launchUrl(Uri.parse(webFallbackUrl),
            mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Google Maps';
      }
    }
  } catch (e) {
    CrashlysticServices.instance.log('Open Google Maps error: $e');
  }
}

  Future<void> openMapNative(
    String cusFullAddress, BuildContext context) async {
  if (Platform.isAndroid) {
    await openGoogleMaps(cusFullAddress);
  } else {
    // Use null safety for position
    Position? position = await PermissionAppService.getCurrentPosition();
    if (position == null) {
      WidgetCommon.showSnackbarErrorGet('Không thể lấy vị trí hiện tại');
      return;
    }

    LatLng _centerPosition = LatLng(position.latitude, position.longitude);
    _mapProvider.setCenterPosition(_centerPosition);
    
    LatLng? _location = await getLatLngFromAddressVMap(cusFullAddress, context);
    if (_location != null) {
      await openGoogleMaps(
        cusFullAddress,
        destinationLatitude: _location.latitude,
        destinationLongitude: _location.longitude,
        sourceLatitude: position.latitude,
        sourceLongitude: position.longitude,
      );
    } else {
      WidgetCommon.showSnackbarErrorGet('Không tìm thấy địa chỉ');
    }
  }
}
Future<void> openMapViewLocationCheckin(
    GlobalKey<ScaffoldState> scaffoldKey,
    String titleCheckin,
    BuildContext context, {
    LatLng? curentMarker,
  }) async {
    if (titleCheckin.trim().isEmpty) {
      WidgetCommon.showSnackbar(scaffoldKey, 'Không tìm thấy tọa độ check in');
      return;
    }

    if (curentMarker == null) {
      WidgetCommon.showSnackbar(scaffoldKey, 'Không tìm thấy tọa độ check in');
      return;
    }

    try {
      final lat = curentMarker.latitude;
      final lng = curentMarker.longitude;
      final coordinates = Uri.encodeComponent('$lat,$lng');

      if (Platform.isAndroid) {
        final googleMapsUrl = 'geo:0,0?q=$coordinates ($titleCheckin)';
        final fallbackUrl =
            'https://play.google.com/store/apps/details?id=com.google.android.apps.maps';

        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl),
              mode: LaunchMode.externalApplication);
        } else {
          return WidgetCommon.generateDialogOKCancelGet(
            'Vui lòng cài đặt Google Maps để sử dụng tính năng này.',
            callbackOK: () async {
              await launchUrl(Uri.parse(fallbackUrl),
                  mode: LaunchMode.externalApplication);
            },
          );
        }
      } else if (Platform.isIOS) {
        final googleMapsUrl =
            'comgooglemaps://?q=$coordinates&zoom=14&views=traffic';
        final webUrl =
            'https://www.google.com/maps/search/?api=1&query=$coordinates';

        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl),
              mode: LaunchMode.externalApplication);
        } else if (await canLaunchUrl(Uri.parse(webUrl))) {
          await launchUrl(Uri.parse(webUrl),
              mode: LaunchMode.externalApplication);
        } else {
          throw 'Không thể mở Google Maps';
        }
      }
    } catch (e) {
      CrashlysticServices.instance
          .log('Lỗi khi mở bản đồ location checkin: $e');
    }
  }
  Future<Response> searchPositionMap(String keyword) async {
    return await _searchService.getPagingList(1, keyword, '');
  }
}

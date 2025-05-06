import 'dart:convert';

import 'package:get/get.dart';
import 'package:athena/getit.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/login/login.service.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/utils.dart';

class GuideController extends GetxController {
  final loginService = new LoginService();
    final _userInfoStore = getIt<UserInfoStore>();
  var videos = [];
  var documents = [];
  var policys = [];

  @override
  void onReady() {
    super.onReady();
    this.handleFirstLayout();
  }

  Future<void> handleFirstLayout() async {
    try {
      videos = [];
      //
      if (Utils.isTenantTnex(_userInfoStore)) {
        final dynamic response = await loginService.getVersionAppp();
        if (Utils.checkIsNotNull(response)) {
          var data = Utils.handleRequestData(response);
          if (Utils.checkIsNotNull(data)) {
            data = json.decode(response.data['data']);
            final _videos = data['learningVideo'];
            final _documents = data['learningDocument'];
            videos = _videos;
            documents = _documents;
            policys = data['policys'] ?? [];
          }
        }
      } else {
        documents = [
          {
            'title': 'Hướng dẫn sử dụng',
            'link':
                'https://dr00e7jyhxoyd.cloudfront.net/rmi/AthenaCompanyProfile.pdf',
            'type': 'pdf'
          }
        ];
      }
    } catch (e) {
      print(e);
    } finally {
      update([
        'GuiControllerVideo',
        'GuiControllerPolicys',
        'GuiControllerDocument'
      ]);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AppsController extends GetxController {
  final homeProvider = getIt<HomeProvider>();
  List<AppsModel> lstApps = [];
  final _userInfoStore = getIt<UserInfoStore>();

  var documents = [];
  var policys = [];

  @override
  void onReady() {
    super.onReady();
    this.handleFirstLayout();
  }

  Future<void> handleFirstLayout() async {
    await Future.delayed(Duration(milliseconds: 300));
    try {
      lstApps = [];
      if (Utils.checkIsNotNull(homeProvider.appDataConfig)) {
        final apps = homeProvider.appDataConfig['apps'];
        if (Utils.isArray(apps)) {
          bool isAdd = false;
          for (var app in apps) {
            isAdd = false;
            final appModel = new AppsModel.fromJson(app);
            if (appModel.functions != null &&
                appModel.functions!.isNotEmpty &&
                Utils.isArray(appModel.functions)) {
              for (String func in appModel.functions!) {
                if (_userInfoStore.checkPerimission(func)) {
                  isAdd = true;
                  break;
                }
              }
            }
            if (!isAdd && Utils.isArray(appModel.roles)) {
              if (appModel.roles != null &&
                  appModel.roles!.isNotEmpty &&
                  Utils.isArray(appModel.roles)) {
                for (String role in appModel.roles!) {
                  if (_userInfoStore.checkRoles(role)) {
                    isAdd = true;
                    break;
                  }
                }
              }
            }
            if (isAdd) {
              lstApps.add(appModel);
            }
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      update(['AppsController']);
    }
  }

  @override
  void dispose() {
    super.dispose();
    lstApps = [];
  }
}

class AppsModel {
  String title = '';
  String link = '';
  String page = '';
  List<String>? roles;
  List<String>? functions;

  AppsModel(
      {required this.title, required this.link, this.roles, this.functions});

  AppsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    link = json['link'];
    page = json['page'];
    if (Utils.isArray(json['roles'])) {
      roles = json['roles'].cast<String>();
    }
    if (Utils.isArray(json['functions'])) {
      functions = json['functions'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['link'] = this.link;
    data['page'] = this.page;
    data['roles'] = this.roles;
    data['functions'] = this.functions;
    return data;
  }
}

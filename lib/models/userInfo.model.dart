import 'dart:convert';
import 'permission/permission.model.dart';

class UserInfoModel {
  UserInfoModel({
    this.userCode,
    this.username,
    this.fullName,
    this.moreInfo,
    this.permissions,
    this.authorities,
    this.password,
    this.accountNonExpired,
    this.accountNonLocked,
    this.credentialsNonExpired,
    this.enabled,
    this.email,
    this.aggId,
  });

  final String? password;
  final String? username;
  final List<Authority>? authorities;
  final bool? accountNonExpired;
  final bool? accountNonLocked;
  final bool? credentialsNonExpired;
  final bool? enabled;
  final Map<String, dynamic>? moreInfo;
  final String? fullName;
  final String? email;
  final String? aggId;
  final String? userCode;
  final List<PermissionModel>? permissions;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        username: json['username'] as String?,
        fullName: json['fullName'] as String?,
        moreInfo: json['moreInfo'] as Map<String, dynamic>?,
        userCode: json['userCode'] as String?,
        permissions: json['permissions'] == null
            ? null
            : List<PermissionModel>.from(
                (json['permissions'] as List).map(
                  (x) => PermissionModel.fromJson(x as Map<String, dynamic>),
                ),
              ),
        authorities: json['authorities'] == null
            ? null
            : List<Authority>.from(
                (json['authorities'] as List).map(
                  (x) => Authority.fromJson(x as Map<String, dynamic>),
                ),
              ),
        password: json['password'] as String?,
        accountNonExpired: json['accountNonExpired'] as bool?,
        accountNonLocked: json['accountNonLocked'] as bool?,
        credentialsNonExpired: json['credentialsNonExpired'] as bool?,
        enabled: json['enabled'] as bool?,
        email: json['email'] as String?,
        aggId: json['aggId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'fullName': fullName,
        'moreInfo': moreInfo,
        'userCode': userCode,
        'permissions': permissions?.map((x) => x.toJson()).toList(),
        'authorities': authorities?.map((x) => x.toJson()).toList(),
        'password': password,
        'accountNonExpired': accountNonExpired,
        'accountNonLocked': accountNonLocked,
        'credentialsNonExpired': credentialsNonExpired,
        'enabled': enabled,
        'email': email,
        'aggId': aggId,
      };
}

class UserRolesModel {
  UserRolesModel({
    required this.authorities,
  });

  final List<Authority> authorities;

  factory UserRolesModel.fromJson(Map<String, dynamic> json) => UserRolesModel(
        authorities: (json["authorities"] as List<dynamic>?)
                ?.map((x) => Authority.fromJson(x as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "authorities": authorities.map((x) => x.toJson()).toList(),
      };
}

class Authority {
  Authority({
    this.authority,
  });

  final String? authority;

  factory Authority.fromJson(Map<String, dynamic> json) => Authority(
        authority: json["authority"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "authority": authority,
      };
}
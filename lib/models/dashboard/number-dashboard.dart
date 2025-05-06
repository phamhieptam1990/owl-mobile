import 'package:flutter/material.dart';

class NumberDashboardModel {
  String? title;
  String? subTitle;
  IconData? icon;
  Function? action;
  List<Data>? data;
  NumberDashboardModel(
      {this.title, this.subTitle, this.icon, this.data, this.action});

  NumberDashboardModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['subTitle'];
    icon = json['icon'];
    if (json['data'] != null) {
      data = [];
      json['pieCharts'].forEach((v) {
        data?.add(new Data.fromJson(v));
      });
    }
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['icon'] = icon;
    data['data'] = this.data?.map((v) => v.toJson()).toList();
      data['action'] = action;
    return data;
  }
}

class Data {
  String? name;
  Color? color;
  String? linkImage;
  String? number;
  String? unit;
  Function? action;
  IconData? icon;
  Data(
      {this.name,
      this.color,
      this.linkImage,
      this.number,
      this.action,
      this.icon,
      this.unit});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
    linkImage = json['linkImage'];
    number = json['number'];
    action = json['action'];
    unit = json['unit'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['color'] = color;
    data['linkImage'] = linkImage;
    data['number'] = number;
    data['action'] = action;
    data['unit'] = unit;
    data['icon'] = icon;
    return data;
  }
}

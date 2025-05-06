import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class AddressModel extends Equatable {
  String? applId;
  String? dateStatus;
  String? lastStatus;
  String? contractNumber;
  String? currentAddress;
  String? officeAddress;
  String? permanentAddress;

  AddressModel({
    this.applId,
    this.dateStatus,
    this.lastStatus,
    this.contractNumber,
    this.currentAddress,
    this.officeAddress,
    this.permanentAddress,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    applId = json['applId'];
    dateStatus = json['dateStatus'];
    lastStatus = json['lastStatus'];
    contractNumber = json['contractNumber'];
    currentAddress = json['currentAddress'];
    officeAddress = json['officeAddress'];
    permanentAddress = json['permanentAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['applId'] = applId;
    data['dateStatus'] = dateStatus;
    data['lastStatus'] = lastStatus;
    data['contractNumber'] = contractNumber;
    data['currentAddress'] = currentAddress;
    data['officeAddress'] = officeAddress;
    data['permanentAddress'] = permanentAddress;
    return data;
  }

  @override
  List<Object?> get props => [
        applId,
        dateStatus,
        lastStatus,
        contractNumber,
        currentAddress,
        officeAddress,
        permanentAddress,
      ];
}
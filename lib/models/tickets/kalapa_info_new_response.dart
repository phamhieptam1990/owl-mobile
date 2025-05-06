class KalapaInfoNewResponse {
  KalapaInfoNewResponse({
    this.status,
    this.data,
  });

  final int? status;
  final KalapaInfoNewData? data;

  factory KalapaInfoNewResponse.fromJson(Map<String, dynamic> json) =>
      KalapaInfoNewResponse(
        status: json["status"],
        data: json["data"] != null ? KalapaInfoNewData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class KalapaInfoNewData {
  KalapaInfoNewData({
    this.code,
    this.msg,
    this.outOfDate,
    this.messages,
    this.resultData,
  });

  final int? code;
  final String? msg;
  final bool? outOfDate;
  final ResultData? resultData;
  final List<String>? messages;

  factory KalapaInfoNewData.fromJson(Map<String, dynamic> json) =>
      KalapaInfoNewData(
        code: json["code"],
        msg: json["msg"],
        outOfDate: json["outOfDate"],
        messages: json["messages"] != null
            ? List<String>.from(json["messages"].map((x) => x))
            : null,
        resultData: json["resultData"] != null
            ? ResultData.fromJson(json["resultData"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "outOfDate": outOfDate,
        "resultData": resultData?.toJson(),
        "messages": messages != null ? List<dynamic>.from((messages??[]).map((x) => x)) : null,
      };
}

class ResultData {
  ResultData({
    this.sys,
    this.mobileFriends,
    this.topFacebookFriends,
    this.cusInfos,
    this.tlInfos,
    this.hiMemInfos,
    this.hiFamilyReps,
    this.hiInfos,
    this.othrAppInfos,
    this.facebookCusInfo,
  });

  final Sys? sys;
  final List<MobileFriend>? mobileFriends;
  final List<TopFacebookFriend>? topFacebookFriends;
  final List<CusInfo>? cusInfos;
  final FacebookCusInfo? facebookCusInfo;
  final List<TlInfo>? tlInfos;
  final List<Hi>? hiMemInfos;
  final List<Hi>? hiFamilyReps;
  final List<Hi>? hiInfos;
  final OthrAppInfos? othrAppInfos;

  factory ResultData.fromJson(Map<String, dynamic> json) => ResultData(
        sys: json["Sys"] != null ? Sys.fromJson(json["Sys"]) : null,
        mobileFriends: json["fbTopFriend"] != null
            ? List<MobileFriend>.from(
                json["fbTopFriend"].map((x) => MobileFriend.fromJson(x)))
            : null,
        topFacebookFriends: json["fbTopFriends"] != null
            ? List<TopFacebookFriend>.from(
                json["fbTopFriends"].map((x) => TopFacebookFriend.fromJson(x)))
            : null,
        cusInfos: json["cusInfos"] != null
            ? List<CusInfo>.from(
                json["cusInfos"].map((x) => CusInfo.fromJson(x)))
            : null,
        facebookCusInfo: json["mobile"] != null || json["fbLink"] != null || json["fbName"] != null
            ? FacebookCusInfo.fromJson(json)
            : null,
        tlInfos: json["tlInfos"] != null
            ? List<TlInfo>.from(json["tlInfos"].map((x) => TlInfo.fromJson(x)))
            : null,
        hiMemInfos: json["hiMemInfos"] != null
            ? List<Hi>.from(json["hiMemInfos"].map((x) => Hi.fromJson(x)))
            : null,
        hiFamilyReps: json["hiFamilyReps"] != null
            ? List<Hi>.from(json["hiFamilyReps"].map((x) => Hi.fromJson(x)))
            : null,
        hiInfos: json["hiInfos"] != null
            ? List<Hi>.from(json["hiInfos"].map((x) => Hi.fromJson(x)))
            : null,
        othrAppInfos: json["othrAppInfos"] != null
            ? OthrAppInfos.fromJson(json["othrAppInfos"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "Sys": sys?.toJson(),
        "fbTopFriend": mobileFriends != null
            ? List<dynamic>.from((mobileFriends??[]).map((x) => x.toJson()))
            : null,
        "fbTopFriends": topFacebookFriends != null
            ? List<dynamic>.from((topFacebookFriends??[]).map((x) => x.toJson()))
            : null,
        "cusInfos": cusInfos != null
            ? List<dynamic>.from((cusInfos?? []).map((x) => x.toJson()))
            : null,
        "tlInfos": tlInfos != null
            ? List<dynamic>.from((tlInfos??[]).map((x) => x.toJson()))
            : null,
        "hiMemInfos": hiMemInfos != null
            ? List<dynamic>.from((hiMemInfos??[]).map((x) => x.toJson()))
            : null,
        "hiFamilyReps": hiFamilyReps != null
            ? List<dynamic>.from((hiFamilyReps?? []).map((x) => x.toJson()))
            : null,
        "hiInfos": hiInfos != null
            ? List<dynamic>.from((hiInfos?? []).map((x) => x.toJson()))
            : null,
        "othrAppInfos": othrAppInfos?.toJson(),
      };
}

class CusInfo {
  CusInfo({
    this.nationalId,
    this.nationalId2,
    this.fullname,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dob,
    this.permanentAddress,
    this.permanentAddrStreet,
    this.permanentAddrWard,
    this.permanentAddrDistrict,
    this.permanentAddrProvinceCity,
    this.currentAddress,
    this.currentAddrStreet,
    this.currentAddrWard,
    this.currentAddrDistrict,
    this.currentAddrProvinceCity,
    this.socialInsuranceId,
    this.siInfos,
  });

  final String? nationalId;
  final String? nationalId2;
  final String? fullname;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final String? dob;
  final String? permanentAddress;
  final String? permanentAddrStreet;
  final String? permanentAddrWard;
  final String? permanentAddrDistrict;
  final String? permanentAddrProvinceCity;
  final String? currentAddress;
  final String? currentAddrStreet;
  final String? currentAddrWard;
  final String? currentAddrDistrict;
  final String? currentAddrProvinceCity;
  final String? socialInsuranceId;
  final List<SiInfo>? siInfos;

  factory CusInfo.fromJson(Map<String, dynamic> json) => CusInfo(
        nationalId: json["nationalID"],
        nationalId2: json["nationalID2"],
        fullname: json["fullname"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        dob: json["dob"],
        permanentAddress: json["permanentAddress"],
        permanentAddrStreet: json["permanent_addr_street"],
        permanentAddrWard: json["permanent_addr_ward"],
        permanentAddrDistrict: json["permanent_addr_district"],
        permanentAddrProvinceCity: json["permanent_addr_province_city"],
        currentAddress: json["currentAddress"],
        currentAddrStreet: json["current_addr_street"],
        currentAddrWard: json["current_addr_ward"],
        currentAddrDistrict: json["current_addr_district"],
        currentAddrProvinceCity: json["current_addr_province_city"],
        socialInsuranceId: json["socialInsuranceId"],
        siInfos: json["siInfos"] != null
            ? List<SiInfo>.from(json["siInfos"].map((x) => SiInfo.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "nationalID": nationalId,
        "nationalID2": nationalId2,
        "fullname": fullname,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "gender": gender,
        "dob": dob,
        "permanentAddress": permanentAddress,
        "permanent_addr_street": permanentAddrStreet,
        "permanent_addr_ward": permanentAddrWard,
        "permanent_addr_district": permanentAddrDistrict,
        "permanent_addr_province_city": permanentAddrProvinceCity,
        "currentAddress": currentAddress,
        "current_addr_street": currentAddrStreet,
        "current_addr_ward": currentAddrWard,
        "current_addr_district": currentAddrDistrict,
        "current_addr_province_city": currentAddrProvinceCity,
        "socialInsuranceId": socialInsuranceId,
        "siInfos": siInfos != null
            ? List<dynamic>.from((siInfos??[]).map((x) => x.toJson()))
            : null,
      };
}

class SiInfo {
  SiInfo({
    this.siTransactionAmount,
    this.startDate,
    this.endDate,
    this.position,
    this.companyName,
    this.companyAddress,
    this.companyTaxCode,
    this.companySizeCode,
    this.companySalaryPercentile,
    this.nationalSalaryPercentile,
    this.healthInsuranceId,
    this.healthInsuranceDesc,
    this.companySiId,
    this.increaseDecreaseCode,
    this.baseSalary,
    this.contactPersonName,
    this.contactPersonPhone,
    this.contactPersonEmail,
  });

  final String? siTransactionAmount;
  final String? startDate;
  final String? endDate;
  final String? position;
  final String? companyName;
  final String? companyAddress;
  final String? companyTaxCode;
  final String? companySizeCode;
  final String? companySalaryPercentile;
  final String? nationalSalaryPercentile;
  final String? healthInsuranceId;
  final String? healthInsuranceDesc;
  final String? companySiId;
  final String? increaseDecreaseCode;
  final String? baseSalary;
  final String? contactPersonName;
  final String? contactPersonPhone;
  final String? contactPersonEmail;

  factory SiInfo.fromJson(Map<String, dynamic> json) => SiInfo(
        siTransactionAmount: json["siTransactionAmount"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        position: json["position"],
        companyName: json["companyName"],
        companyAddress: json["companyAddress"],
        companyTaxCode: json["companyTaxCode"],
        companySizeCode: json["companySizeCode"],
        companySalaryPercentile: json["companySalaryPercentile"],
        nationalSalaryPercentile: json["nationalSalaryPercentile"],
        healthInsuranceId: json["healthInsuranceId"],
        healthInsuranceDesc: json["healthInsuranceDesc"],
        companySiId: json["companySiId"],
        increaseDecreaseCode: json["increaseDecreaseCode"],
        baseSalary: json["baseSalary"],
        contactPersonName: json["contactPersonName"],
        contactPersonPhone: json["contactPersonPhone"],
        contactPersonEmail: json["contactPersonEmail"],
      );

  Map<String, dynamic> toJson() => {
        "siTransactionAmount": siTransactionAmount,
        "startDate": startDate,
        "endDate": endDate,
        "position": position,
        "companyName": companyName,
        "companyAddress": companyAddress,
        "companyTaxCode": companyTaxCode,
        "companySizeCode": companySizeCode,
        "companySalaryPercentile": companySalaryPercentile,
        "nationalSalaryPercentile": nationalSalaryPercentile,
        "healthInsuranceId": healthInsuranceId,
        "healthInsuranceDesc": healthInsuranceDesc,
        "companySiId": companySiId,
        "increaseDecreaseCode": increaseDecreaseCode,
        "baseSalary": baseSalary,
        "contactPersonName": contactPersonName,
        "contactPersonPhone": contactPersonPhone,
        "contactPersonEmail": contactPersonEmail,
      };
}

class MobileFriend {
  MobileFriend({
    this.seqNum,
    this.fbFriendMobile,
  });

  final dynamic seqNum;
  final String? fbFriendMobile;

  factory MobileFriend.fromJson(Map<String, dynamic> json) => MobileFriend(
        seqNum: json["seqNum"],
        fbFriendMobile: json["fb_friend_mobile"],
      );

  Map<String, dynamic> toJson() => {
        "seqNum": seqNum,
        "fb_friend_mobile": fbFriendMobile,
      };
}

class TopFacebookFriend {
  TopFacebookFriend({
    this.seqNum,
    this.fbLink,
    this.fbName,
  });

  final dynamic seqNum;
  final String? fbLink;
  final String? fbName;

  factory TopFacebookFriend.fromJson(Map<String, dynamic> json) =>
      TopFacebookFriend(
        seqNum: json["seqNum"],
        fbLink: json["fbLink"],
        fbName: json["fbName"],
      );

  Map<String, dynamic> toJson() => {
        "seqNum": seqNum,
        "fbLink": fbLink,
        "fbName": fbName,
      };
}

class Hi {
  Hi({
    this.nationalId,
    this.fullname,
    this.gender,
    this.dob,
    this.hiId,
    this.fulladdress,
    this.addrStreet,
    this.addrWard,
    this.addrDistrict,
    this.addrProvinceCity,
    this.hiMembers,
    this.mobile,
  });

  final String? nationalId;
  final String? fullname;
  final String? gender;
  final String? dob;
  final String? hiId;
  final String? fulladdress;
  final String? addrStreet;
  final String? addrWard;
  final String? addrDistrict;
  final String? addrProvinceCity;
  final List<HiMember>? hiMembers;
  final String? mobile;

  factory Hi.fromJson(Map<String, dynamic> json) => Hi(
        nationalId: json["nationalID"],
        fullname: json["fullname"],
        gender: json["gender"],
        dob: json["dob"],
        hiId: json["hi_id"],
        fulladdress: json["fulladdress"],
        addrStreet: json["addr_street"],
        addrWard: json["addr_ward"],
        addrDistrict: json["addr_district"],
        addrProvinceCity: json["addr_province_city"],
        hiMembers: json["hiMembers"] != null
            ? List<HiMember>.from(
                json["hiMembers"].map((x) => HiMember.fromJson(x)))
            : null,
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "nationalID": nationalId,
        "fullname": fullname,
        "gender": gender,
        "dob": dob,
        "hi_id": hiId,
        "fulladdress": fulladdress,
        "addr_street": addrStreet,
        "addr_ward": addrWard,
        "addr_district": addrDistrict,
        "addr_province_city": addrProvinceCity,
        "hiMembers": hiMembers != null
            ? List<dynamic>.from((hiMembers??[]).map((x) => x.toJson()))
            : null,
        "mobile": mobile,
      };
}

class HiMember {
  HiMember({
    this.memFullname,
    this.memGender,
    this.memDob,
    this.memHiId,
  });

  final String? memFullname;
  final String? memGender;
  final String? memDob;
  final String? memHiId;

  factory HiMember.fromJson(Map<String, dynamic> json) => HiMember(
        memFullname: json["mem_fullname"],
        memGender: json["mem_gender"],
        memDob: json["mem_dob"],
        memHiId: json["mem_hi_id"],
      );

  Map<String, dynamic> toJson() => {
        "mem_fullname": memFullname,
        "mem_gender": memGender,
        "mem_dob": memDob,
        "mem_hi_id": memHiId,
      };
}

class OthrAppInfos {
  OthrAppInfos({this.reUseFlag, this.lastUpdatedDate});

  final String? reUseFlag;
  final String? lastUpdatedDate;

  factory OthrAppInfos.fromJson(Map<String, dynamic> json) => OthrAppInfos(
        reUseFlag: json["RE_USE_FLAG"],
        lastUpdatedDate: json["LAST_UPDATED_DATE"],
      );

  Map<String, dynamic> toJson() => {
        "RE_USE_FLAG": reUseFlag,
        "LAST_UPDATED_DATE": lastUpdatedDate,
      };
}

class Sys {
  Sys({
    this.transId,
    this.dateTime,
    this.code,
    this.description,
  });

  final String? transId;
  final DateTime? dateTime;
  final String? code;
  final String? description;

  factory Sys.fromJson(Map<String, dynamic> json) => Sys(
        transId: json["TransID"],
        dateTime: json["DateTime"] != null ? DateTime.parse(json["DateTime"]) : null,
        code: json["Code"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "TransID": transId,
        "DateTime": dateTime?.toIso8601String(),
        "Code": code,
        "Description": description,
      };
}

class TlInfo {
  TlInfo({
    this.nationalId,
    this.fullname,
    this.dob,
    this.mobileInfos,
  });

  final String? nationalId;
  final String? fullname;
  final String? dob;
  final List<MobileInfo>? mobileInfos;

  factory TlInfo.fromJson(Map<String, dynamic> json) => TlInfo(
        nationalId: json["nationalID"],
        fullname: json["fullname"],
        dob: json["dob"],
        mobileInfos: json["mobileInfos"] != null
            ? List<MobileInfo>.from(
                json["mobileInfos"].map((x) => MobileInfo.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "nationalID": nationalId,
        "fullname": fullname,
        "dob": dob,
        "mobileInfos": mobileInfos != null
            ? List<dynamic>.from((mobileInfos??[]).map((x) => x.toJson()))
            : null,
      };
}

class MobileInfo {
  MobileInfo({
    this.mobile,
    this.fulladdress,
    this.addrStreet,
    this.addrWard,
    this.addrDistrict,
    this.addrProvinceCity,
  });

  final String? mobile;
  final String? fulladdress;
  final String? addrStreet;
  final String? addrWard;
  final String? addrDistrict;
  final String? addrProvinceCity;

  factory MobileInfo.fromJson(Map<String, dynamic> json) => MobileInfo(
        mobile: json["mobile"],
        fulladdress: json["fulladdress"],
        addrStreet: json["addr_street"],
        addrWard: json["addr_ward"],
        addrDistrict: json["addr_district"],
        addrProvinceCity: json["addr_province_city"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "fulladdress": fulladdress,
        "addr_street": addrStreet,
        "addr_ward": addrWard,
        "addr_district": addrDistrict,
        "addr_province_city": addrProvinceCity,
      };
}

class FacebookCusInfo {
  final String? mobile;
  final String? fbLink;
  final String? fbName;

  FacebookCusInfo({this.mobile, this.fbLink, this.fbName});

  factory FacebookCusInfo.fromJson(Map<String, dynamic> json) =>
      FacebookCusInfo(
        mobile: json["mobile"],
        fbLink: json["fbLink"],
        fbName: json["fbName"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "fbLink": fbLink,
        "fbName": fbName,
      };
}
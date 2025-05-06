class ContactNewModel {
  dynamic education;
  dynamic fbownerNid;
  dynamic cstmContactType;
  dynamic joinDate;
  dynamic cstbContactDocs;
  int? id;
  dynamic fax;
  String? homePhone;
  dynamic buCode;
  dynamic socialStatus;
  String? idno;
  dynamic cstbContactReferees;
  dynamic fbownerRelation;
  String? firstName;
  dynamic idnoPlace;
  String? fbnumber;
  dynamic cstbContactAddresses;
  dynamic ftsValue;
  dynamic maritalStatus;
  ExtraInfo? extraInfo;
  dynamic status;
  String? lastName;
  dynamic annualIncome;
  String? code;
  String? gender;
  String? tenantCode;
  dynamic title;
  String? fbownerContactno;
  int? modNo;
  dynamic fbissueDate;
  dynamic checkerDate;
  String? idnoDate;
  String? ftsStringValue;
  dynamic email;
  dynamic fbtype;
  String? makerId;
  dynamic buId;
  String? fbname;
  String? makerDate;
  String? authStatus;
  dynamic citizenship;
  dynamic sex;
  String? fullName;
  String? birthDate;
  String? recordStatus;
  dynamic annualExpenses;
  dynamic checkerId;
  String? middleName;
  String? aggId;
  dynamic contactTypeId;
  String? cellPhone;

  ContactNewModel({
    this.education,
    this.fbownerNid,
    this.cstmContactType,
    this.joinDate,
    this.cstbContactDocs,
    this.id,
    this.fax,
    this.homePhone,
    this.buCode,
    this.socialStatus,
    this.idno,
    this.cstbContactReferees,
    this.fbownerRelation,
    this.firstName,
    this.idnoPlace,
    this.fbnumber,
    this.cstbContactAddresses,
    this.ftsValue,
    this.maritalStatus,
    required this.extraInfo,
    this.status,
    this.lastName,
    this.annualIncome,
    this.code,
    this.gender,
    this.tenantCode,
    this.title,
    this.fbownerContactno,
    this.modNo,
    this.fbissueDate,
    this.checkerDate,
    this.idnoDate,
    this.ftsStringValue,
    this.email,
    this.fbtype,
    this.makerId,
    this.buId,
    this.fbname,
    this.makerDate,
    this.authStatus,
    this.citizenship,
    this.sex,
    this.fullName,
    this.birthDate,
    this.recordStatus,
    this.annualExpenses,
    this.checkerId,
    this.middleName,
    this.aggId,
    this.contactTypeId,
    this.cellPhone,
  });

  ContactNewModel.fromJson(Map<String, dynamic> json) {
    education = json['education'];
    fbownerNid = json['fbownerNid'];
    cstmContactType = json['cstmContactType'];
    joinDate = json['joinDate'];
    cstbContactDocs = json['cstbContactDocs'];
    id = json['id'];
    fax = json['fax'];
    homePhone = json['homePhone'];
    buCode = json['buCode'];
    socialStatus = json['socialStatus'];
    idno = json['idno'];
    cstbContactReferees = json['cstbContactReferees'];
    fbownerRelation = json['fbownerRelation'];
    firstName = json['firstName'];
    idnoPlace = json['idnoPlace'];
    fbnumber = json['fbnumber'];
    cstbContactAddresses = json['cstbContactAddresses'];
    ftsValue = json['ftsValue'];
    maritalStatus = json['maritalStatus'];
    extraInfo = json['extraInfo'] != null
        ? ExtraInfo.fromJson(json['extraInfo'])
        : ExtraInfo();
    status = json['status'];
    lastName = json['lastName'];
    annualIncome = json['annualIncome'];
    code = json['code'];
    gender = json['gender'];
    tenantCode = json['tenantCode'];
    title = json['title'];
    fbownerContactno = json['fbownerContactno'];
    modNo = json['modNo'];
    fbissueDate = json['fbissueDate'];
    checkerDate = json['checkerDate'];
    idnoDate = json['idnoDate'];
    ftsStringValue = json['ftsStringValue'];
    email = json['email'];
    fbtype = json['fbtype'];
    makerId = json['makerId'];
    buId = json['buId'];
    fbname = json['fbname'];
    makerDate = json['makerDate'];
    authStatus = json['authStatus'];
    citizenship = json['citizenship'];
    sex = json['sex'];
    fullName = json['fullName'];
    birthDate = json['birthDate'];
    recordStatus = json['recordStatus'];
    annualExpenses = json['annualExpenses'];
    checkerId = json['checkerId'];
    middleName = json['middleName'];
    aggId = json['aggId'];
    contactTypeId = json['contactTypeId'];
    cellPhone = json['cellPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['education'] = education;
    data['fbownerNid'] = fbownerNid;
    data['cstmContactType'] = cstmContactType;
    data['joinDate'] = joinDate;
    data['cstbContactDocs'] = cstbContactDocs;
    data['id'] = id;
    data['fax'] = fax;
    data['homePhone'] = homePhone;
    data['buCode'] = buCode;
    data['socialStatus'] = socialStatus;
    data['idno'] = idno;
    data['cstbContactReferees'] = cstbContactReferees;
    data['fbownerRelation'] = fbownerRelation;
    data['firstName'] = firstName;
    data['idnoPlace'] = idnoPlace;
    data['fbnumber'] = fbnumber;
    data['cstbContactAddresses'] = cstbContactAddresses;
    data['ftsValue'] = ftsValue;
    data['maritalStatus'] = maritalStatus;
    data['extraInfo'] = extraInfo?.toJson();
    data['status'] = status;
    data['lastName'] = lastName;
    data['annualIncome'] = annualIncome;
    data['code'] = code;
    data['gender'] = gender;
    data['tenantCode'] = tenantCode;
    data['title'] = title;
    data['fbownerContactno'] = fbownerContactno;
    data['modNo'] = modNo;
    data['fbissueDate'] = fbissueDate;
    data['checkerDate'] = checkerDate;
    data['idnoDate'] = idnoDate;
    data['ftsStringValue'] = ftsStringValue;
    data['email'] = email;
    data['fbtype'] = fbtype;
    data['makerId'] = makerId;
    data['buId'] = buId;
    data['fbname'] = fbname;
    data['makerDate'] = makerDate;
    data['authStatus'] = authStatus;
    data['citizenship'] = citizenship;
    data['sex'] = sex;
    data['fullName'] = fullName;
    data['birthDate'] = birthDate;
    data['recordStatus'] = recordStatus;
    data['annualExpenses'] = annualExpenses;
    data['checkerId'] = checkerId;
    data['middleName'] = middleName;
    data['aggId'] = aggId;
    data['contactTypeId'] = contactTypeId;
    data['cellPhone'] = cellPhone;
    return data;
  }
}

class ExtraInfo {
  String? dOB;
  dynamic iDNO;
  String? cIFID;
  String? gENDER;
  String? rEMARKS;
  String? sONNUM;
  String? aCTWARD;
  String? fBOWNER;
  String? fULLNAME;
  String? hOMENUM;
  String? rEGWARD;
  String? rEL1NUM;
  String? rEL2NUM;
  dynamic rEL3NUM;
  dynamic fBNUMBER;
  String? pHONEALL;
  String? uNCLENUM;
  String? aCTMOBILE;
  String? aCTMPHONE;
  String? fATHERNUM;
  String? fRIENDNUM;
  dynamic mOBILENUM;
  String? mOTHERNUM;
  String? pER3RDNUM;
  String? rEGMOBILE;
  String? rEGPHONE;
  String? sISTERNUM;
  String? sPOUSENUM;
  String? aCTADDRESS;
  String? bROTHERNUM;
  String? oFFADDRESS;
  String? rEGADDRESS;
  String? aCTDISTRICT;
  String? aCTPROVINCE;
  String? cOMPANYNAME;
  String? dAUGHTERNUM;
  String? pHONEMEMO1;
  String? pHONEMEMO2;
  String? pHONENOTE1;
  String? pHONENOTE2;
  String? rEGDISTRICT;
  String? rEGPROVINCE;
  String? iDISSUEDATE;
  String? pHONEPORTAL1;
  String? pHONEPORTAL2;
  String? jOBDESCRIPTION;
  dynamic sPOUSEPHONENO;
  String? tHIRDPERSONNUM;
  String? bROTHERINLAWNUM;
  String? oTHERRELATIONNUM;
  String? cLOSEDRELATIONNUM;
  String? CITIZEN_ID_NUMBER;
  String? CITIZEN_ID_ISSUE_PLACE;
  String? CITIZEN_ID_ISSUE_DATE;
  String? ACT_MOBILE;
  dynamic ACCOUNT_NUMBER;
  String? ACT_PROVINCE;
  String? ACT_WARD;
  String? REG_ADDRESS;
  String? REG_WARD;
  String? REG_PROVINCE;
  String? ACT_DISTRICT;
  String? REG_DISTRICT;
  String? MARTIAL_STATUS;
  String? FB_OWNER;
  String? FB_NUMBER;
  
  Map<String, dynamic>? _data;

  ExtraInfo({
    this.dOB,
    this.iDNO,
    this.cIFID,
    this.gENDER,
    this.rEMARKS,
    this.sONNUM,
    this.aCTWARD,
    this.fBOWNER,
    this.fULLNAME,
    this.hOMENUM,
    this.rEGWARD,
    this.rEL1NUM,
    this.rEL2NUM,
    this.rEL3NUM,
    this.fBNUMBER,
    this.pHONEALL,
    this.uNCLENUM,
    this.aCTMOBILE,
    this.aCTMPHONE,
    this.fATHERNUM,
    this.fRIENDNUM,
    this.mOBILENUM,
    this.mOTHERNUM,
    this.pER3RDNUM,
    this.rEGMOBILE,
    this.rEGPHONE,
    this.sISTERNUM,
    this.sPOUSENUM,
    this.aCTADDRESS,
    this.bROTHERNUM,
    this.oFFADDRESS,
    this.rEGADDRESS,
    this.aCTDISTRICT,
    this.aCTPROVINCE,
    this.cOMPANYNAME,
    this.dAUGHTERNUM,
    this.pHONEMEMO1,
    this.pHONEMEMO2,
    this.pHONENOTE1,
    this.pHONENOTE2,
    this.rEGDISTRICT,
    this.rEGPROVINCE,
    this.iDISSUEDATE,
    this.pHONEPORTAL1,
    this.pHONEPORTAL2,
    this.jOBDESCRIPTION,
    this.sPOUSEPHONENO,
    this.tHIRDPERSONNUM,
    this.bROTHERINLAWNUM,
    this.oTHERRELATIONNUM,
    this.cLOSEDRELATIONNUM,
    this.CITIZEN_ID_NUMBER,
    this.CITIZEN_ID_ISSUE_PLACE,
    this.CITIZEN_ID_ISSUE_DATE,
    this.ACT_MOBILE,
    this.ACCOUNT_NUMBER,
    this.ACT_PROVINCE,
    this.ACT_WARD,
    this.REG_ADDRESS,
    this.REG_WARD,
    this.REG_PROVINCE,
    this.ACT_DISTRICT,
    this.REG_DISTRICT,
    this.MARTIAL_STATUS,
    this.FB_OWNER,
    this.FB_NUMBER,
  }) {
    _data = {};
  }

  ExtraInfo.fromJson(Map<String, dynamic> json) {
    _data = json;
    try {
      aCTMPHONE = json['aCTMPHONE'];
      rEGPHONE = json['rEGPHONE'];
      dOB = json['DOB'];
      iDNO = json['IDNO'];
      cIFID = json['CIFID'];
      gENDER = json['GENDER'];
      rEMARKS = json['REMARKS'];
      sONNUM = json['SON_NUM'];
      aCTWARD = json['ACT_WARD'];
      fBOWNER = json['FB_OWNER'];
      fULLNAME = json['FULLNAME'];
      hOMENUM = json['HOME_NUM'];
      rEGWARD = json['REG_WARD'];
      rEL1NUM = json['REL1_NUM'];
      rEL2NUM = json['REL2_NUM'];
      rEL3NUM = json['REL3_NUM'];
      fBNUMBER = json['FB_NUMBER'];
      pHONEALL = json['PHONE_ALL'];
      uNCLENUM = json['UNCLE_NUM'];
      aCTMOBILE = json['ACT_MOBILE'];
      fATHERNUM = json['FATHER_NUM'];
      fRIENDNUM = json['FRIEND_NUM'];
      mOBILENUM = json['MOBILE_NUM'];
      mOTHERNUM = json['MOTHER_NUM'];
      pER3RDNUM = json['PER3RD_NUM'];
      rEGMOBILE = json['REG_MOBILE'];
      sISTERNUM = json['SISTER_NUM'];
      sPOUSENUM = json['SPOUSE_NUM'];
      aCTADDRESS = json['ACT_ADDRESS'];
      bROTHERNUM = json['BROTHER_NUM'];
      oFFADDRESS = json['OFF_ADDRESS'];
      rEGADDRESS = json['REG_ADDRESS'];
      aCTDISTRICT = json['ACT_DISTRICT'];
      aCTPROVINCE = json['ACT_PROVINCE'];
      cOMPANYNAME = json['COMPANY_NAME'];
      dAUGHTERNUM = json['DAUGHTER_NUM'];
      pHONEMEMO1 = json['PHONE_MEMO_1'];
      pHONEMEMO2 = json['PHONE_MEMO_2'];
      pHONENOTE1 = json['PHONE_NOTE_1'];
      pHONENOTE2 = json['PHONE_NOTE_2'];
      rEGDISTRICT = json['REG_DISTRICT'];
      rEGPROVINCE = json['REG_PROVINCE'];
      iDISSUEDATE = json['ID_ISSUE_DATE'];
      pHONEPORTAL1 = json['PHONE_PORTAL_1'];
      pHONEPORTAL2 = json['PHONE_PORTAL_2'];
      jOBDESCRIPTION = json['JOB_DESCRIPTION'];
      sPOUSEPHONENO = json['SPOUSE_PHONE_NO'];
      tHIRDPERSONNUM = json['THIRDPERSON_NUM'];
      bROTHERINLAWNUM = json['BROTHERINLAW_NUM'];
      oTHERRELATIONNUM = json['OTHERRELATION_NUM'];
      cLOSEDRELATIONNUM = json['CLOSEDRELATION_NUM'];
      CITIZEN_ID_NUMBER = json['CITIZEN_ID_NUMBER'];
      CITIZEN_ID_ISSUE_DATE = json['CITIZEN_ID_ISSUE_DATE'];
      CITIZEN_ID_ISSUE_PLACE = json['CITIZEN_ID_ISSUE_PLACE'];
      ACT_MOBILE = json['ACT_MOBILE'];
      ACCOUNT_NUMBER = json['ACCOUNT_NUMBER'];
      ACT_PROVINCE = json['ACT_PROVINCE'];
      REG_ADDRESS = json['REG_ADDRESS'];
      REG_WARD = json['REG_WARD'];
      REG_PROVINCE = json['REG_PROVINCE'];
      ACT_DISTRICT = json['ACT_DISTRICT'];
      REG_DISTRICT = json['REG_DISTRICT'];
      MARTIAL_STATUS = json['MARTIAL_STATUS'];
      FB_NUMBER = json['FB_NUMBER'];
      FB_OWNER = json['FB_OWNER'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['aCTMPHONE'] = aCTMPHONE;
      data['rEGPHONE'] = rEGPHONE;
      data['DOB'] = dOB;
      data['IDNO'] = iDNO;
      data['CIFID'] = cIFID;
      data['GENDER'] = gENDER;
      data['REMARKS'] = rEMARKS;
      data['SON_NUM'] = sONNUM;
      data['ACT_WARD'] = aCTWARD;
      data['FB_OWNER'] = fBOWNER;
      data['FULLNAME'] = fULLNAME;
      data['HOME_NUM'] = hOMENUM;
      data['REG_WARD'] = rEGWARD;
      data['REL1_NUM'] = rEL1NUM;
      data['REL2_NUM'] = rEL2NUM;
      data['REL3_NUM'] = rEL3NUM;
      data['FB_NUMBER'] = fBNUMBER;
      data['PHONE_ALL'] = pHONEALL;
      data['UNCLE_NUM'] = uNCLENUM;
      data['ACT_MOBILE'] = aCTMOBILE;
      data['FATHER_NUM'] = fATHERNUM;
      data['FRIEND_NUM'] = fRIENDNUM;
      data['MOBILE_NUM'] = mOBILENUM;
      data['MOTHER_NUM'] = mOTHERNUM;
      data['PER3RD_NUM'] = pER3RDNUM;
      data['REG_MOBILE'] = rEGMOBILE;
      data['SISTER_NUM'] = sISTERNUM;
      data['SPOUSE_NUM'] = sPOUSENUM;
      data['ACT_ADDRESS'] = aCTADDRESS;
      data['BROTHER_NUM'] = bROTHERNUM;
      data['OFF_ADDRESS'] = oFFADDRESS;
      data['REG_ADDRESS'] = rEGADDRESS;
      data['ACT_DISTRICT'] = aCTDISTRICT;
      data['ACT_PROVINCE'] = aCTPROVINCE;
      data['COMPANY_NAME'] = cOMPANYNAME;
      data['DAUGHTER_NUM'] = dAUGHTERNUM;
      data['PHONE_MEMO_1'] = pHONEMEMO1;
      data['PHONE_MEMO_2'] = pHONEMEMO2;
      data['PHONE_NOTE_1'] = pHONENOTE1;
      data['PHONE_NOTE_2'] = pHONENOTE2;
      data['REG_DISTRICT'] = rEGDISTRICT;
      data['REG_PROVINCE'] = rEGPROVINCE;
      data['ID_ISSUE_DATE'] = iDISSUEDATE;
      data['PHONE_PORTAL_1'] = pHONEPORTAL1;
      data['PHONE_PORTAL_2'] = pHONEPORTAL2;
      data['JOB_DESCRIPTION'] = jOBDESCRIPTION;
      data['SPOUSE_PHONE_NO'] = sPOUSEPHONENO;
      data['THIRDPERSON_NUM'] = tHIRDPERSONNUM;
      data['BROTHERINLAW_NUM'] = bROTHERINLAWNUM;
      data['OTHERRELATION_NUM'] = oTHERRELATIONNUM;
      data['CLOSEDRELATION_NUM'] = cLOSEDRELATIONNUM;
      data['CITIZEN_ID_NUMBER'] = CITIZEN_ID_NUMBER;
      data['CITIZEN_ID_ISSUE_DATE'] = CITIZEN_ID_ISSUE_DATE;
      data['CITIZEN_ID_ISSUE_PLACE'] = CITIZEN_ID_ISSUE_PLACE;
      data['ACT_MOBILE'] = ACT_MOBILE;
      data['ACT_PROVINCE'] = ACT_PROVINCE;
      data['REG_ADDRESS'] = REG_ADDRESS;
      data['REG_WARD'] = REG_WARD;
      data['REG_PROVINCE'] = REG_PROVINCE;
      data['ACT_DISTRICT'] = ACT_DISTRICT;
      data['REG_DISTRICT'] = REG_DISTRICT;
      data['MARTIAL_STATUS'] = MARTIAL_STATUS;
      data['FB_NUMBER'] = FB_NUMBER;
      data['FB_OWNER'] = FB_OWNER;
    } catch (e) {
      print(e);
    } finally {
      return data;
    }
  }

  dynamic operator [](String index) => _data![index];
}
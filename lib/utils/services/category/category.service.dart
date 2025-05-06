import 'package:dio/dio.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/utils/http/http_helper.dart';

class CategoryService {
  Future<Response> getTicketStatus() {
    return HttpHelper.get(CATEGORY_URL.TICKET_STATUS);
  }

  Future<Response> getActionTicket() {
    return HttpHelper.get(CATEGORY_URL.TICKET_ACTION);
  }

  Future<Response> getActionTicketById(int id) {
    return HttpHelper.get(CATEGORY_URL.TICKET_ACTION + 'id=$id');
  }

  Future<Response> getAttributeTicket() {
    return HttpHelper.get(CATEGORY_URL.TICKET_ATTRIBUTE);
  }

  Future<Response> getContactWithTicket() {
    return HttpHelper.get(CATEGORY_URL.TICKET_ATTRIBUTE);
  }

  Future<Response> getContactByTicket() {
    return HttpHelper.get(CATEGORY_URL.TICKET_CONTACT_BY);
  }

  Future<Response> getContactByPerson() {
    return HttpHelper.get(CATEGORY_URL.TICKET_CONTACT_PERSON);
  }

  Future<Response> getPlaceContact() {
    return HttpHelper.get(CATEGORY_URL.TICKET_PLACE_CONTACT);
  }

  Future<Response> getLoanTypeTicket() {
    return HttpHelper.get(CATEGORY_URL.TICKET_LOAN_TYPE);
  }

  Future<Response> getActionGroupAndPlace(
      int actionGroupId, int contactPersonId) {
    return HttpHelper.get(CATEGORY_URL.ACTION_GROUP_AND_CONTACT_PLACE +
        'actionGroupId=$actionGroupId&contactPersonId=$contactPersonId');
  }

  Future<Response> getByFieldTypeCode(String fieldTypeCode) {
    return HttpHelper.get(
        CATEGORY_URL.GET_FIELD_TYPE_BY_CODE + 'fieldTypeCode=$fieldTypeCode');
  }

  Future<Response> getAllActionGroup() {
    return HttpHelper.get(CATEGORY_URL.GET_ALL_ACTION_GROUP);
  }

  Future<Response> getAllCategory() {
    return HttpHelper.get(CATEGORY_URL.GET_ALL_CATEGORY_TICKET);
  }

  Future<Response> getAllLocality() {
    return HttpHelper.get(CATEGORY_URL.GET_ALL_LOCALITY);
  }
}

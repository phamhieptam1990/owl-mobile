import 'package:athena/screens/calendar/calendar/calendar.screen.dart';
import 'package:athena/screens/collections/checkPayment/checkPayment.screen.dart';
import 'package:athena/screens/collections/checkin/calendar.screen.dart';
import 'package:athena/screens/collections/checkin/checkin.screen.dart';
import 'package:athena/screens/collections/checkin/otherCheckin.screen.dart';
import 'package:athena/screens/collections/checkin/partialPayment.screen.dart';
import 'package:athena/screens/collections/checkin/promiseToPayment.screen.dart';
import 'package:athena/screens/collections/checkin/refuseToPayment.screen.dart';
import 'package:athena/screens/collections/collection/collections.screen.dart';
import 'package:athena/screens/collections/collection/widget/seeHistoryInformation.screen.dart';
import 'package:athena/screens/collections/collection/widget/viewomnidocs.screen.widget.dart';
import 'package:athena/screens/collections/detail-lv1-read/collections-detail.screen.dart';
import 'package:athena/screens/collections/detail/collections-detail.screen.dart';
import 'package:athena/screens/collections/planned/planned.screen.dart';
// import 'package:athena/screens/customer-complain/customer-complain.screen.dart';
// import 'package:athena/screens/customer-complain/list/customer-complain-detail.screen.dart';
import 'package:athena/screens/customer-request/customer-request.screen.dart';
import 'package:athena/screens/download_list/screen/download_list_screen.dart';
import 'package:athena/screens/filter/collections/filter-collections.screen.dart';
// import 'package:athena/screens/history_transaction_ewallet/screen/history_transaction_ewallet_screen.dart';
import 'package:athena/screens/home/home.screen.dart';
import 'package:athena/screens/login/idile-login.dart';
import 'package:athena/screens/login/login.dart';
// import 'package:athena/screens/login/registration.dart';
import 'package:athena/screens/main/main.screen.dart';
import 'package:athena/screens/search/search.screen.dart';
import 'package:athena/screens/tab/tab.screen.dart';
import 'package:athena/screens/vietmap/vietmap.screen.dart';
import 'package:athena/screens/vietmap/vietmapPosition.screen.dart';

import '../../screens/collections/planned-for-date/planned-for-date.screen.dart';
import '../../screens/vietmap/vietmapPosition_addressTypeId.screen.dart';
import '../../screens/wallet_list/wallet_list_screen.dart';

/// route list constant
class RouteList {
  static const String CHAT_SCREEN = "/chat";
  static const String HOME_SCREEN = "/home";
  static const String PARENT_SCREEN = "/parent";
  static const String LOGIN_SCREEN = "/loginnew";
  static const String LOGIN_IDILE_SCREEN = "/login-idile";
  static const String MAIN_SCREEN = "/main";
  static const String PROFILE_SCREEN = "PROFILE_PAGE";
  static const String SETTING_SCREEN = "SETTINGS";
  static const String NOTIFICATION_SCREEN = "/notification";
  static const String TAB_SCREEN = "/tab";
  static const String SEARCH_SCREEN = "/search";
  static const String COLLECTION_SCREEN = "/collection";
  static const String PLANNED_SCREEN = "/planned";
  static const String PLANNED_FOR_DATE_SCREEN = "/planned-for-date";
  static const String BROWSER_SCREEN = "/browserScreen";
  static const String COLLECTION_DETAIL_SCREEN = "/collection-detail";
  static const String COLLECTION_DETAIL_LV1_READ_ONLY_SCREEN =
      "/collection-detail-readonly";
  // static const String MAP_SCREEN = "/map";
  static const String VIETMAP_SCREEN = "/vietmap";
  // static const String MAP_SCREEN_POSITION = "/map-position";
  static const String VIETMAP_SCREEN_POSITION = "/vietmap-position";
   static const String VIETMAP_SCREEN_POSITION_TYPE_ID = "/vietmap-position-typeid";
  static const String CALENDAR_SCREEN = "/calendar";
  static const String FILTER_COLLECTION = "/filter-collection";
  static const String TRACKING_CREEN = "/tracking-screen";
  static const String FILTER_TRACKING = "/filter-tracking";
  // static const String FILTER_COLLECTION_TEAM = "/filter-collection-team";
  static const String CHECK_IN = "/check-in";
  static const String PROMISE_TO_PAYMENT = "/promise-to-payment";
  static const String PARTICAL_PAYMENT = "/partical-payment";
  static const String REFUSE_TO_PAYMENT = "/refuse-to-payment";
  static const String FULL_PAYMENT = "/full-payment";
  static const String OTHER_CHECK_IN = "/other-checkin";
  static const String CALENDAR_TICKET = "/calendar-ticket";
  static const String CHECK_PAYMENT_SCREEN = "/check-payment";
  static const String CHECK_HISTORY_PAYMENT_SCREEN = "/check-history-payment";
  static const String VIEW_OMNI_DOCS = "/view-omnidocs";
  static const String CHECK_PAYMENT_SCREEN_DETAIL = "/check-payment-detail";
  static const String CUSTOMER_COMPLAIN_SCREEN = "/customer-complain";
  static const String CUSTOMER_COMPLAIN_DETAIL_SCREEN =
      "/customer-complain-detail";
  static const String CALENDAR_TICKET_SCREEN = 'calendar-ticket-screen';
  static const String CUSTOMER_REQUEST_SCREEN = "/customer-request";
  static const String DETAIL_ACTION_FEATURE = "/detail-action-feature";
  static const String DOWNLOAD_LIST_SCREEN = "/download-list-screen";
  static const String WALLET_LIST_SCREEN = "/wallet-list-screen";
  static const String TRANSACTION_WALLET_LIST_SCREEN =
      "/transaction-wallet-list-screen";

  static var routesApp = {
    MAIN_SCREEN: (context) => MainScreen(),
    LOGIN_SCREEN: (context) => LoginScreen(),
    LOGIN_IDILE_SCREEN: (context) => IdileLogin(),
    HOME_SCREEN: (context) => HomeScreen(),
    TAB_SCREEN: (context) => TabScreen(),
    SEARCH_SCREEN: (context) => SearchScreen(),
    COLLECTION_SCREEN: (context) => CollectionScreen(),
    COLLECTION_DETAIL_SCREEN: (context) => CollectionDetailScreen(),
    COLLECTION_DETAIL_LV1_READ_ONLY_SCREEN: (context) =>
        CollectionDetailLv1ReadScreen(),
    // MAP_SCREEN: (context) => MapScreen(),
    VIETMAP_SCREEN: (context) => VietMapScreen(),
    CALENDAR_SCREEN: (context) => CalendarScreen(),
    FILTER_COLLECTION: (context) => FilterCollectionScreen(),
    CHECK_IN: (context) => CheckInScreen(),
    PROMISE_TO_PAYMENT: (context) => PromiseToPaymentScreen(),
    PARTICAL_PAYMENT: (context) => ParticalPaymentScreen(),
    FULL_PAYMENT: (context) => ParticalPaymentScreen(),
    OTHER_CHECK_IN: (context) => OtherCheckInScreen(),
    REFUSE_TO_PAYMENT: (context) => RefuseToPaymentScreen(),
    CALENDAR_TICKET: (context) => CalendarTicketScreen(),
    // MAP_SCREEN_POSITION: (context) => MapScreenPosition(),
    VIETMAP_SCREEN_POSITION: (context) => VietMapScreenPosition(),
     VIETMAP_SCREEN_POSITION_TYPE_ID: (context) => VietMapScreenAddressTypeIdPosition(),
    CHECK_PAYMENT_SCREEN: (context) => CheckPaymentScreen(),
    // CUSTOMER_COMPLAIN_SCREEN: (context) => CustomerComplainScreen(),
    // CUSTOMER_COMPLAIN_DETAIL_SCREEN: (context) =>
    //     CustomerComplaintDetailScreen(),
    CALENDAR_TICKET_SCREEN: (context) => CalendarTicketScreen(),
    CUSTOMER_REQUEST_SCREEN: (context) => CustomerRequestScreen(),
    // FILTER_COLLECTION_TEAM: (context) => FilterCollectionTeamScreen(),
    VIEW_OMNI_DOCS: (context) => ViewOmniDocsScreen(),
    CHECK_HISTORY_PAYMENT_SCREEN: (context) => SeeHistoryInfomationScreen(),
    // DETAIL_ACTION_FEATURE: (context) => DetailActionFeatureScreen(),
    PLANNED_SCREEN: (context) => PlannedScreen(),
    PLANNED_FOR_DATE_SCREEN: (context) => PlannedForDateScreen(),
    DOWNLOAD_LIST_SCREEN: (context) => DownloadListScreen(),
    WALLET_LIST_SCREEN: (context) => WalletListScreen(),
    // TRANSACTION_WALLET_LIST_SCREEN: (context) =>
    //     HistoryTransactionEWalletScreen(),
  };
}

import 'package:athena/screens/vietmap/vietmap.provider.dart';
import 'package:get_it/get_it.dart';
import 'package:athena/screens/calendar/calendar/calendar.provider.dart';
import 'package:athena/screens/collections/checkin/checkin.provider.dart';
import 'package:athena/screens/collections/collection/collections.provider.dart';
import 'package:athena/screens/filter/collections/hierarchy/hiearchy.provider.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/screens/notification/notification.provider.dart';
import 'package:athena/screens/recovery/recovery.provider.dart';
import 'package:athena/screens/search/search.provider.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/services/employee/employee.provider.dart';

import 'utils/services/certificate/CertSecurityContext.dart';

final getIt = GetIt.instance;
Future<void> setup() async {
  CertSecurityContext certSecurityContext = CertSecurityContext();
  await certSecurityContext.addTrustedCertificatesBytes();
  getIt.registerSingleton<CertSecurityContext>(certSecurityContext);

  getIt.registerLazySingleton<CollectionProvider>(() => CollectionProvider());
  getIt.registerLazySingleton<EmployeeProvider>(() => EmployeeProvider());
  getIt.registerLazySingleton<CheckInProvider>(() => CheckInProvider());
  getIt.registerLazySingleton<UserInfoStore>(() => UserInfoStore());
  getIt.registerLazySingleton<HomeProvider>(() => HomeProvider());
  getIt.registerLazySingleton<SearchProvider>(() => SearchProvider());
  getIt.registerLazySingleton<NotificationProvider>(
      () => NotificationProvider());
  getIt.registerLazySingleton<CalendarProvider>(() => CalendarProvider());
  // getIt.registerLazySingleton<MapProvider>(() => MapProvider());
  getIt.registerLazySingleton<VietMapProvider>(() => VietMapProvider());
  getIt.registerLazySingleton<FilterCollectionsProvider>(
      () => FilterCollectionsProvider());
  getIt.registerLazySingleton<RecoveryProvider>(() => RecoveryProvider());
  getIt.registerLazySingleton<HiearchyProvider>(() => HiearchyProvider());
}

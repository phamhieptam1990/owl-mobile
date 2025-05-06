import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:athena/utils/storage/storage_helper.dart';

import '../../getit.dart';
import '../global-store/user_info_store.dart';
import '../services/category/category.provider.dart';
import '../utils.dart';

class MasterDataManager {
  static FirebaseFirestore? _firestore;
  static const String cacheVersionKey = 'cacheVersionKey';
  
  // Singleton implementation
  static MasterDataManager? _instance;
  
  factory MasterDataManager() {
    _instance ??= MasterDataManager._internal();
    return _instance!;
  }

  // Make currentVersion nullable and initialize as empty string
  static String? currentVersion;
  
  MasterDataManager._internal() {
    _firestore = FirebaseFirestore.instance;
  }

  static void listenCacheCurrentVersion() {
    try {
      MasterDataManager();
      _firestore!
          .collection('app')
          .doc('cache_current_time')
          .snapshots()
          .listen((event) async {
        if (event.data() != null) {
          final data = event.data()!;
          currentVersion = data['current_version'] as String?;
          
          //  final newVersion = NewVersionPlus();
          // final status = await newVersion.getVersionStatus();
          final localVersion = Utils.showVersionApp();
          if (localVersion != currentVersion) {
            final _categoryProvider = CategorySingeton();
            _categoryProvider.initAllCateogyData(isClearData: true);
          }
        }
      });
    } catch (e) {
      debugPrint('Error in listenCacheCurrentVersion: $e');
    }
  }

  static Future<void> saveCacheCurrentVersion() async {
    // Check if currentVersion is null or empty
  if (currentVersion?.isEmpty ?? true) return;
    
    try {
      await StorageHelper.setString(cacheVersionKey, currentVersion!);
    } catch (e) {
      debugPrint('Error saving cache version: $e');
    }
  }

  static Future<bool> isReloadMasterData(String newVersion) async {
    try {
      final userInfoStore = getIt<UserInfoStore>();
      bool isLogedin = userInfoStore.getUser() != null;
      final cacheMasterDataVersion =
          await StorageHelper.getString(cacheVersionKey);
          
      if (cacheMasterDataVersion != newVersion && isLogedin) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error in isReloadMasterData: $e');
      return false;
    }
  }
}
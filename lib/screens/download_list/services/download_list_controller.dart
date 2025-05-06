import 'package:get/get.dart';
import 'package:athena/screens/download_list/models/download_list_response.dart';

import 'download_list_services.dart';

class DownloadListController extends GetxController {
  DownloadListData? data;
  bool isLoading = false;
  int currentPage = 0;
  bool enablePullUp = false;
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void fetchData() async {
    isLoading = true;

    try {
      final response = await DownloadListServices().getContactDocs(currentPage);
      // Fix 3: Handle null response properly
      if (response == null) {
        isLoading = false;
        update();
        return;
      }

      // Fix 4: Add null check for response.status
      if (response.status == 0) {
        // Fix 5: Add null check for response.data
        if (response.data != null) {
          data = response.data!;
          
          // Fix 6: Add null check for data.lastRow
          enablePullUp = data?.lastRow == -1;
        }
      }
      isLoading = false;
      update();
    } catch (e) {
      print(e.toString());
      isLoading = false;
      update();
    }
  }

  Future<void> onLoadmoreData() async {
    try {
      if (enablePullUp) {
        // Fix 8: Add null check for response
        final response = 
            await DownloadListServices().getContactDocs(++currentPage);
            
        // Fix 9: Handle null response properly
        if (response == null) {
          update();
          return;
        }
        
        // Fix 10: Add null check for response.status
        if (response.status == 0) {
          // Fix 11: Add null check for response.data and data.checkinItems
          if (response.data != null && response.data?.checkinItems != null) {
            // Fix 12: Add null check for data.checkinItems
            final currentItems = data?.checkinItems ?? [];
            
            currentItems.addAll(response.data?.checkinItems ??[]);
            
            // Fix 13: Update data with new items
            data = DownloadListData(
              checkinItems: currentItems,
              lastRow: response.data?.lastRow
            );
            
            // Fix 14: Add null check for response.data?.lastRow
            enablePullUp = response.data?.lastRow == -1;
          }
        }
        update();
      }
    } catch (e) {
      print(e.toString());
      update();
    }
  }
}

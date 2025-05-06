import 'package:get/get.dart' as GETX;
import 'package:athena/common/constants/general.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/services/camera.service.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/utils/services/savefile.service.dart';

class ProfileController extends GETX.GetxController {
  final appState = new AppState();
  final ticketService = new DMSService();
  final cameraService = new CameraService();
  final saveFileService = new SaveFileService();
  bool isLoadComplete = false;
  final String path = AppStateConfigConstant.PLACE_HOLDER_IMAGE;

  @override
  void onReady() {
    super.onReady();
    this.afterFirstLayout();
  }

  void afterFirstLayout() async {
    if (appState.isCheckShowAvatarComplete) {
      if (appState.pathFileAvatar.isEmpty) {
        appState.pathFileAvatar = await saveFileService.getPathFileAvatar();
      }
      isLoadComplete = true;
    }
    update(['ProfileScreen']);
  }
}

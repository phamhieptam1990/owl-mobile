import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import '../appbar.dart';

class CameraScreen extends StatefulWidget {
  final bool canSwitchCamera;
  final bool isFrontCamera;
  CameraScreen(this.canSwitchCamera, this.isFrontCamera);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController? cameraController;
  List cameras = [];
  int selectedCameraIndex = 0;
  String? imgPath;



  Future<void> initCamera(CameraDescription cameraDescription) async {
    // Nếu controller đã tồn tại và đã initialized, dispose trước
  if (cameraController != null && cameraController!.value.isInitialized){
      await cameraController?.dispose();
    }

    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    cameraController?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    try {
      await cameraController?.initialize();
    } catch (e) {
      showCameraException(e);
    }

    // if (cameraController?.value.hasError) {
    //   print("Camera error: ${cameraController?.value.errorDescription}");
    // }

    if (mounted) {
      setState(() {});
    }
  }


  /// Display camera preview
  Widget cameraPreview() {
  if (cameraController == null || !cameraController!.value.isInitialized) {
  // Handle camera not ready

      return const Center(
        child: Text(
          'Loading',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return CameraPreview(cameraController!); // dùng ! vì đã check null ở trên
  }

  Widget cameraControl(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.camera,
                color: AppColor.white,
                size: 30,
              ),
              backgroundColor: AppColor.primary,
              onPressed: () {
                onCapture(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget cameraToggle() {
    if (cameras.isEmpty) {
      return Spacer();
    }
    if (widget.canSwitchCamera == false) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
            onPressed: () {
              onSwitchCamera();
            },
            icon: Icon(
              getCameraLensIcons(lensDirection),
              color: Colors.white,
              size: 30,
            ),
            label: Text(
              '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            )),
      ),
    );
  }

  onCapture(context) async {
    try {
      var value = await cameraController?.takePicture();
      final file = new File(value?.path ??'');
      // Fix: Use correct parameter name for the navigation service
      // Check NavigationService.goback() method to use the correct parameter name
      if (context.mounted) {
        // Option 1: If NavigationService.goback() expects 'result' parameter
        await NavigationService.instance.goback(result: file);

        // Option 2: If there's no named parameter, just pass the file directly
        // await NavigationService.instance.goback(file);
      }
    } catch (e) {
      showCameraException(e);
    }
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      if (cameras.length > 0) {
        for (int index = 0; index < cameras.length; index++) {
          CameraDescription cam = cameras[index];
          if (widget.isFrontCamera) {
            if (cam.lensDirection == CameraLensDirection.front) {
              selectedCameraIndex = index;
              break;
            }
          } else {
            selectedCameraIndex = index;
            break;
          }
        }
        setState(() {});
        initCamera(cameras[selectedCameraIndex]).then((value) {});
      } else {
        WidgetCommon.showSnackbar(scaffoldKey, 'No camera available');
      }
    }).catchError((e) {
      showCameraException(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommon(lstWidget: [], title: 'Chụp ảnh'),
      body: Container(
        height: AppState.getHeightDevice(context),
        width: AppState.getWidthDevice(context),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: cameraPreview(),
              width: AppState.getWidthDevice(context),
              height: AppState.getHeightDevice(context),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: AppState.getWidthDevice(context),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      cameraToggle(),
                      cameraControl(context),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getCameraLensIcons(lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return CupertinoIcons.photo_camera;
      default:
        return Icons.device_unknown;
    }
  }

  onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    initCamera(selectedCamera);
  }

  void showCameraException(e) {
    WidgetCommon.generateDialogOKGet(
        content: 'Error message: ${e.description}');
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (Utils.checkIsNotNull(cameraController)) {
      cameraController?.dispose();
    }
  }
}

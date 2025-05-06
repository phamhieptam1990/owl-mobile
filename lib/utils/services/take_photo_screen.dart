import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePhotoScreen extends StatefulWidget {
  final bool isForceSelfie;

  TakePhotoScreen({Key? key, this.isForceSelfie = false}) : super(key: key);

  @override
  _TakePhotoScreenState createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  List<CameraDescription> cameras = [];
  @override
  void initState() {
    selectedCamera = widget.isForceSelfie ? 1 : 0;
    Future.delayed(Duration(milliseconds: 400), () {
      initializeCamera(selectedCamera); //Initially selectedCamera = 0
    });
    super.initState();
  }

  CameraController? _controller; //To control the camera
  late Future<void>
      _initializeControllerFuture; //Future to wait until camera initializes
  int selectedCamera = 0;
  List<File> capturedImages = [];

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  Future<void> initializeCamera(int cameraIndex) async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint('No cameras available');
        return;
      }

      final newController = CameraController(
        cameras[selectedCamera],
        ResolutionPreset.medium,
      );

      // Dispose previous controller if exists
      await _controller?.dispose();
      _controller = newController;

      // Initialize the controller
      _initializeControllerFuture = newController.initialize().then((_) {
        if (mounted) setState(() {});
      });

      await _initializeControllerFuture;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Spacer(),
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return Container(
                  child: Center(child: _cameraPreviewWidget()),
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                );
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final controller = _controller;
                    if (controller == null || !controller.value.isInitialized) {
                      return;
                    }

                    if (controller.value.isTakingPicture) {
                      return;
                    }

                    try {
                      final XFile file = await controller.takePicture();
                      if (mounted) {
                        Navigator.pop(context, file.path);
                      }
                    } on CameraException catch (_) {
                      return null;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Container(
                      height: 66,
                      width: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed:
                          _controller != null ? () => onSwapCamera() : null,
                      icon:
                          Icon(Icons.find_replace_rounded, color: Colors.white),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: _controller?.value.isInitialized ?? false
                          ? () {
                              final controller = _controller;
                              if (controller == null) return;

                              onFlashModeButtonPressed(
                                  controller.value.flashMode != FlashMode.torch
                                      ? FlashMode.torch
                                      : FlashMode.off);
                            }
                          : null,
                      icon: Icon(Icons.highlight,
                          color: _controller?.value.flashMode == FlashMode.torch
                              ? Colors.orange
                              : Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  void onFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
    });
  }

  void onSwapCamera() {
    this.setState(() {
      /// Change the current selected camera State.
      selectedCamera = selectedCamera == 0 ? 1 : 0;
    });

    initializeCamera(selectedCamera);
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      final controller = _controller;
      if (controller == null || !controller.value.isInitialized) return;
      await controller.setFlashMode(mode);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error setting flash mode: $e');
    }
  }

  Widget _cameraPreviewWidget() {
    final cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Camera initializing...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    if (!cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          cameraController,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (_pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await _controller?.setZoomLevel(_currentScale);
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }
}

import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/services/camera.service.dart';
import 'package:athena/widgets/common/photo/galleryPhotoViewWrapper.widget.dart';

class MainScreen extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigator;
  MainScreen({Key? key, this.navigator}) : super(key: key);

  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with AfterLayoutMixin {
  
  List<File> listImage = [];
  dynamic preAttachment = [], postAttachment = [];
  List<File> listFilePost = [];
  List<FileLocal> galleryItemHistoryLocal = [];
  List<FileLocal> galleryItemHistoryPreLocal = [];
  List<File> galleryItems = [],
      galleryItemHistory = [],
      galleryItemHistoryPre = [];
  bool verticalGallery = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(S.of(context).cart),
      ),
      body: Container(
        height: AppState.getHeightDevice(context),
        width: AppState.getWidthDevice(context),
        child: (listImage.isEmpty) ? Text("No") : buildListImage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildListImage() {
    List<Widget> lstWidget = [];
    int index = 0;
    for (File image in listImage) {
      // galleryItemHistoryLocal.add(new FileLocal("312", "321", image));
      lstWidget.add(new Stack(
        children: [
          Padding(
              padding: EdgeInsets.zero,
              child: InkWell(
                onTap: () async {
                  removeImage(index);
                },
                child: Icon(
                  Icons.remove_circle,
                  size: 50.0,
                  color: Colors.red,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: Container(
                height: 100.0,
                width: 100.0,
                child: TextButton(
                  child: new Image.file(image, width: 100.0, height: 100.0),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => GalleryPhotoViewWrapper(
                    //       dataPost: postAttachment,
                    //       galleryItems: galleryItemHistoryLocal,
                    //       backgroundDecoration: const BoxDecoration(
                    //         color: Colors.white,
                    //       ),
                    //       initialIndex: index++,
                    //       scrollDirection:
                    //           verticalGallery ? Axis.vertical : Axis.horizontal,
                    //     ),
                    //   ),
                    // );
                    NavigationService.instance.navigateToRoute(
                      MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                          dataPost: postAttachment,
                          galleryItems: galleryItemHistoryLocal,
                          backgroundDecoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          initialIndex: index++,
                          scrollDirection:
                              verticalGallery ? Axis.vertical : Axis.horizontal,
                        ),
                      ),
                    );
                  },
                )),
          )
        ],
      ));
      index++;
    }
    return Container(
      height: 200.0,
      width: double.infinity,
      child: Row(
        children: lstWidget,
      ),
    );
  }

  Future<void> removeImage(int index) async {
    this.listImage.clear();
    setState(() {});
  }

  void _incrementCounter() async {
    CameraService cameraService = new CameraService();
    File? _image = await cameraService.takePicture();
    if (_image == null) {
      return;
    }
    setState(() {
      listImage.add(_image);
        });
  }

  @override
  void dispose() {
    // listImage = null;
    listImage.clear();
    listFilePost.clear();
    galleryItemHistory.clear();
    galleryItemHistoryPre.clear();
    galleryItems.clear();
    galleryItemHistoryLocal.clear();
    galleryItemHistoryPreLocal.clear();
    super.dispose();
  }
}

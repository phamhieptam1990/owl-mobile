import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:athena/widgets/common/view_html/ViewPdfWidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'browser.screen.dart';
import 'package:get/get.dart';
import '../setting.controller.dart';

class GuideScreen extends StatelessWidget {
  final guideController = Get.put(GuideController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 58, 184, 62),
                  Color.fromARGB(255, 38, 134, 45),
                  Color.fromARGB(255, 6, 51, 9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
             labelColor: Colors.white, // màu của tab được chọn
            unselectedLabelColor: Colors.white70, // màu của tab chưa được chọn
            indicatorColor: Colors.white, 
            labelStyle: TextStyle(fontSize: 18.0),
            tabs: [
              Tab(
                text: 'Tài liệu',
              ),
              Tab(
                text: 'Video',
              ),
            ],
          ),
          title: Text('Hướng dẫn sử dụng'),
        ),
        body: TabBarView(
          children: [
            listDocument(),
            listVideo(),
          ],
        ),
      ),
    );
  }

  Widget listVideo() {
    return GetBuilder<GuideController>(
        id: 'GuiControllerVideo',
        builder: (_) => (guideController.videos.length > 0)
            ? ListView.separated(
                itemCount: guideController.videos.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(guideController.videos[index]['title']),
                    contentPadding: EdgeInsets.only(
                        left: 7.0, right: 7.0, top: 0, bottom: 0),
                    onTap: () async {
                      await playVideo(guideController.videos[index]['link'],
                          guideController.videos[index]['title']);
                    },
                  );
                },
              )
            : NoDataWidget());
  }

  // Widget listPolicy() {
  //   return GetBuilder<GuideController>(
  //       id: 'GuiControllerPolicys',
  //       builder: (_) => (guideController.policys.length > 0)
  //           ? ListView.separated(
  //               itemCount: guideController.policys.length,
  //               separatorBuilder: (BuildContext context, int index) =>
  //                   Divider(),
  //               itemBuilder: (BuildContext context, int index) {
  //                 return ListTile(
  //                   title: Text(guideController.policys[index]['title']),
  //                   contentPadding: EdgeInsets.only(
  //                       left: 7.0, right: 7.0, top: 0, bottom: 0),
  //                   onTap: () async {
  //                     await playPolicy(
  //                         guideController.policys[index]['link'],
  //                         guideController.policys[index]['title'],
  //                         guideController.policys[index]['type']);
  //                   },
  //                 );
  //               },
  //             )
  //           : NoDataWidget());
  // }

  Widget listDocument() {
    return GetBuilder<GuideController>(
        id: 'GuiControllerDocument',
        builder: (_) => (guideController.documents.length > 0)
            ? ListView.separated(
                itemCount: guideController.documents.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(guideController.documents[index]['title']),
                    contentPadding: EdgeInsets.only(
                        left: 7.0, right: 7.0, top: 0, bottom: 0),
                    onTap: () async {
                      await viewDocument(
                          guideController.documents[index]['link'],
                          guideController.documents[index]['title'],
                          guideController.documents[index]['type']);
                    },
                  );
                },
              )
            : NoDataWidget());
  }

  Future<void> playVideo(link, title) async {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => YoutubePage(
    //               ids: [link],
    //               title: title,
    //             )));
    Get.to(() => YoutubePage(
          ids: [link],
          title: title,
        ));
  }

  Future<void> playWeb(link, title) async {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => BrowserScreen(url: link, title: title)));
    Get.to(() => BrowserScreen(url: link, title: title));
  }

  Future<void> viewDocument(link, title, type) async {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ViewPDFWidget(
    //               url: link,
    //               title: title,
    //               isDownload: true,
    //             )));
    Get.to(() => ViewPDFWidget(
          url: link,
          title: title,
          isDownload: true,
        ));
  }

  Future<void> playPolicy(link, title, type) async {
    if (!Utils.checkIsNotNull(type)) {
      await this.viewDocument(link, title, type);
    } else if (type == 'pdf') {
      await this.viewDocument(link, title, type);
    } else if (type == 'video') {
      await this.playVideo(link, title);
    } else if (type == 'html') {
      await this.playWeb(link, title);
    }
  }
}

/// Homepage
class YoutubePage extends StatefulWidget {
  final List<String> ids;
  final String title;
  YoutubePage({Key? key, required this.ids, required this.title}) : super(key: key);
  @override
  _YoutubePageState createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  YoutubePlayerController? _controller;
  TextEditingController? _idController;
  TextEditingController? _seekToController;

  PlayerState _playerState = PlayerState.unknown;
  YoutubeMetaData _videoMetaData = const YoutubeMetaData();
  double _volume = 50;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: false,
        hideThumbnail: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

void listener() {
    if (_isPlayerReady &&
        mounted &&
        _controller != null &&
        !_controller!.value.isFullScreen) {
      setState(() {
        _playerState = _controller!.value.playerState;
        _videoMetaData = _controller!.metadata;
      });
    }
  }


  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _idController?.dispose();
    _seekToController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCommon(
          title: widget.title,
          lstWidget: [],
        ),
        body: YoutubePlayerBuilder(
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          player: YoutubePlayer(
            controller: _controller!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            topActions: <Widget>[
              Expanded(
                child: Text(
                  _controller?.metadata.title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            ],
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {
              // _controller.load(widget.ids[
              //     (widget.ids.indexOf(data.videoId) + 1) % widget.ids.length]);
            },
          ),
          builder: (context, player) => Scaffold(
            body: Container(
              child: player,
              height: AppState.getHeightDevice(context),
              width: AppState.getWidthDevice(context),
            ),
          ),
        ));
  }
}

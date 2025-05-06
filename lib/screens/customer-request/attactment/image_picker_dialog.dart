import 'dart:async';
import 'package:flutter/material.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/customer-request/attactment/image_picker_handler.dart';

class ImagePickerDialog extends StatelessWidget {
  final ImagePickerHandler _listener;
  final AnimationController _controller;
  BuildContext? context;

  ImagePickerDialog(this._listener, this._controller){
      initState();
  }

   Animation<double>? _drawerContentsOpacity;
   Animation<Offset>? _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    _controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => new SlideTransition(
        position: _drawerDetailsPosition!,
        child: new FadeTransition(
          opacity: new ReverseAnimation(_drawerContentsOpacity!),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context!);
  }

  dismissDialog() {
    _controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    var cameraTitle = S.of(context).camera;
    var imageTitle = S.of(context).image;
    var pickmultiFile = S.of(context).pickmultiFile;
    var creatavideo = S.of(context).creatavideo;
    var btCancel = S.of(context).btCancel;
    // var intTheme= Provider.of<ThemeStore>(context).themeIndex;
    this.context = context;
    return new Material(
        type: MaterialType.transparency,
        child: new Opacity(
          opacity: 1.0,
          child: new Container(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new GestureDetector(
                  onTap: () => _listener.takePicture(),
                  child: roundedButton(
                      cameraTitle,
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      // Colors.greenAccent,
                      Theme.of(context).primaryColor,
                      Colors.white),
                ),
                new GestureDetector(
                  onTap: () => _listener.getPicture(),
                  child: roundedButton(
                      imageTitle,
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      // Colors.greenAccent,
                      Theme.of(context).primaryColor,
                      Colors.white),
                ),
                new GestureDetector(
                  onTap: () => _listener.pickMultiFile(context),
                  child: roundedButton(
                      pickmultiFile,
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      // Colors.greenAccent,
                      Theme.of(context).primaryColor,
                      Colors.white),
                ),
                const SizedBox(height: 15.0),
                new GestureDetector(
                  onTap: () => dismissDialog(),
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: roundedButton(
                        btCancel,
                        EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        Colors.red,
                        Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

// actionFile(){
//   // _loadingPath = true;
//   _listener.pickMultiFile();
// }
  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(100.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
}

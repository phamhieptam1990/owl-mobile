import 'package:flutter/material.dart';
import 'package:athena/common/config/app_config.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final String forgotPasswordUrl = APP_CONFIG.FORGET_PASSWORD;

  final TextEditingController forgotPasswordController =
      TextEditingController();

  bool isSubmitting = false;

  // void onSubmitPassword(BuildContext context) async {
  //   FocusScope.of(context).unfocus();
  //   String userName = forgotPasswordController.text;
  //   if (userName.isEmpty) {
  //     final snackBar = SnackBar(
  //       content: Text(S.of(context).emptyUsername),
  //       duration: Duration(seconds: 3),
  //     );
  //     Scaffold.of(context).showSnackBar(snackBar);
  //     return;
  //   }
  //   Map<String, dynamic> data = {'user_login': userName};
  //   setState(() {
  //     isSubmitting = true;
  //   });

  //   await Provider.of<UserModel>(context, listen: false)
  //       .submitForgotPassword(forgotPwLink: forgotPasswordUrl, data: data)
  //       .then((val) {
  //     final snackBar = SnackBar(
  //       content: Text(val),
  //       duration: Duration(seconds: 3),
  //     );
  //     Scaffold.of(context).showSnackBar(snackBar);
  //     setState(() {
  //       isSubmitting = false;
  //     });

  //     if (val == 'Check your email for confirmation link') {
  //       Future.delayed(Duration(seconds: 1), () => Navigator.of(context).pop());
  //     }
  //   });
  // }

  @override
  void dispose() {
    forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    // return Scaffold(
    //   backgroundColor: Theme.of(context).backgroundColor,
    //   appBar: AppBar(
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back),
    //       onPressed: () => Navigator.of(context).pop(),
    //     ),
    //     backgroundColor: Theme.of(context).backgroundColor,
    //   ),
    //   body: Builder(
    //     builder: (context) => SafeArea(
    //       child: Container(
    //         alignment: Alignment.center,
    //         width:
    //             screenSize.width / (2 / (screenSize.height / screenSize.width)),
    //         child: SingleChildScrollView(
    //           padding: const EdgeInsets.symmetric(horizontal: 30.0),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 S.of(context).resetYourPassword,
    //                 style: TextStyle(
    //                     fontSize: 30.0, color: Theme.of(context).primaryColor),
    //               ),
    //               const SizedBox(
    //                 height: 40.0,
    //               ),
    //               const Icon(
    //                 Icons.vpn_key,
    //                 color: Colors.orangeAccent,
    //                 size: 70.0,
    //               ),
    //               const SizedBox(
    //                 height: 20.0,
    //               ),
    //               TextField(
    //                 controller: forgotPasswordController,
    //                 decoration: InputDecoration(
    //                   hintText: S.of(context).yourUsernameEmail,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 30.0,
    //               ),
    //               InkWell(
    //                 onTap: () =>
    //                     isSubmitting ? null : onSubmitPassword(context),
    //                 child: Container(
    //                   height: 50.0,
    //                   width: 200.0,
    //                   decoration: BoxDecoration(
    //                     color: Theme.of(context).primaryColor,
    //                     borderRadius:
    //                         BorderRadius.all(const Radius.circular(25.0)),
    //                   ),
    //                   child: Center(
    //                     child: isSubmitting
    //                         ? kLoadingWidget(context)
    //                         : Text(
    //                             S.of(context).getPasswordLink,
    //                             style: TextStyle(
    //                               color: Colors.white,
    //                               fontSize: 16.0,
    //                               fontWeight: FontWeight.w300,
    //                               letterSpacing: 0.3,
    //                             ),
    //                           ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 50.0,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Container();
  }
}

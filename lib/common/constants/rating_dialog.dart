// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:athena/common/constants/app_icons.dart';
// import 'package:athena/common/constants/color.dart';

// import 'base_button_app.dart';

// class RatingDialog extends StatefulWidget {
//   final String titleRating;
//   final String note;
//   final int ratingValue;

//   const RatingDialog(
//       {Key key, this.titleRating = '', this.note = '', this.ratingValue = 1})
//       : super(key: key);
//   @override
//   _RatingDialogState createState() => _RatingDialogState();
// }

// class _RatingDialogState extends State<RatingDialog> {
//   TextEditingController controller = TextEditingController();
//   int ratingValue;

//   @override
//   void initState() {
//     // TODO: implement initState
//     controller.text = widget?.note ?? '';
//     ratingValue = widget?.ratingValue;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Center(
//         child: Text(
//           widget?.titleRating,
//           maxLines: 3,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               color: AppColor.primary,
//               fontSize: 15,
//               fontWeight: FontWeight.w700),
//         ),
//       ),
//       content: Container(
//         height: 200,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             RatingBar(
//                 itemSize: 30,
//                 initialRating: widget?.ratingValue?.toDouble() ?? 1.0,
//                 direction: Axis.horizontal,
//                 allowHalfRating: false,
//                 itemCount: 5,
//                 itemPadding: const EdgeInsets.symmetric(horizontal: 5),
//                 ratingWidget: RatingWidget(
//                     full: Image.asset(
//                       AppIcons.icFullStar,
//                       width: 10,
//                       height: 10,
//                       fit: BoxFit.cover,
//                     ),
//                     half: Image.asset(
//                       AppIcons.icHaftStar,
//                       width: 10,
//                       height: 10,
//                       fit: BoxFit.cover,
//                     ),
//                     empty: Image.asset(
//                       AppIcons.icEmptyStar,
//                       width: 10,
//                       height: 10,
//                       fit: BoxFit.cover,
//                     )),
//                 onRatingUpdate: (rating) {
//                   setState(() {
//                     ratingValue = rating.toInt();
//                   });
//                 }),
//             TextField(
//               controller: controller,
//               keyboardType: TextInputType.multiline,
//               textInputAction: TextInputAction.done,
//               keyboardAppearance: Brightness.light,
//               maxLines: 5,
//               enableSuggestions: false,
//               autocorrect: false,
//               minLines: 3,
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600),
//               decoration: InputDecoration(
//                 hintText: 'Nội dung đánh giá',
//                 contentPadding: const EdgeInsets.all(10),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(7.0),
//                   borderSide: BorderSide(
//                     color: AppColor.primary,
//                   ),
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(7.0),
//                   borderSide: BorderSide(
//                     color: Colors.red,
//                   ),
//                 ),
//               ),
//             ),
//             BaseButtonApp(
//               title: 'Cập nhật',
//               onTap: () {
//                 // Navigator.pop(
//                 //     context,
//                 //     RatingDataArgs(
//                 //         ratingValue: ratingValue, note: controller.text));
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

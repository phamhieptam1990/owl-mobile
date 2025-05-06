import 'package:flutter/material.dart';

import '../../../../common/constants/color.dart';
import '../../../../models/fileLocal.model.dart';
import '../../../../utils/navigation/navigation.service.dart';
import '../../../../widgets/common/photo/galleryPhotoViewWrapper.widget.dart';

class ImageSelfieWidget extends StatelessWidget {
  const ImageSelfieWidget(
      {Key? key,
      required this.imgList,
      required this.index,
      required this.onRemove,
      this.showRemove = true})
      : super(key: key);

  final List<FileLocal> imgList;
  final int index;
  final bool showRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 16, bottom: 16),
            child: InkWell(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child: new Image.file(imgList[index].file, height: 120.0)),
              onTap: () {
                NavigationService.instance.navigateToRoute(MaterialPageRoute(
                  builder: (context) => GalleryPhotoViewWrapper(
                    dataPost: [],
                    galleryItems: imgList,
                    initialIndex: index,
                    scrollDirection: Axis.horizontal,
                  ),
                ));
              },
            ),
          ),
          showRemove ?? false
              ? Positioned(
                  top: 0,
                  left: 0,
                  child: InkWell(
                      onTap: () {
                        if (showRemove) {
                          onRemove.call();
                        }
                      },
                      child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColor.red),
                              color: AppColor.white,
                              shape: BoxShape.circle),
                          child: Icon(Icons.delete_forever,
                              color: AppColor.red.withOpacity(.6)))),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

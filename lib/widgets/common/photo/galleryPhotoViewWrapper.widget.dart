import 'package:flutter/material.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:athena/widgets/common/appbar.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    Key? key,
    this.dataPost,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);
  final dataPost;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<FileLocal> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int? currentIndex;

  final GlobalKey<ScaffoldState> _scaffoldKeySub =
      new GlobalKey<ScaffoldState>(debugLabel: 'GalleryPhotoViewWrapper');
  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeySub,
      appBar: AppBarCommon(
        title: "",
        lstWidget: [],
      ),
      body: Container(
        // decoration: widget.backgroundDecoration,
        // constraints: BoxConstraints.expand(
        //   height: MediaQuery.of(context).size.height,
        // ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
          ],
        ),
      ),
    );
  }

  
  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    if (widget.galleryItems.isEmpty) {
      return PhotoViewGalleryPageOptions(
        imageProvider: const AssetImage('assets/images/placeholder.png'),
        initialScale: PhotoViewComputedScale.contained,
        heroAttributes: PhotoViewHeroAttributes(tag: 'empty'),
      );
    }

    return PhotoViewGalleryPageOptions(
      imageProvider: FileImage(widget.galleryItems[index].file),
      initialScale: PhotoViewComputedScale.contained * 0.8,
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: index.toString()),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

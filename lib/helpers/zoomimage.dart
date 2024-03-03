import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final tags;
  ZoomImage({this.imageProvider, this.tags});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: GestureDetector(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ]),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            margin: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: kToolbarHeight - 20, bottom: 20),
            child: Hero(
              tag: '$tags',
              child: ClipRect(
                child: PhotoView(
                  enableRotation: true,
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  imageProvider: imageProvider,
                  backgroundDecoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ]),
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

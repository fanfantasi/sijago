import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemImage extends StatelessWidget {
  final images;
  const ItemImage({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white),
        width: MediaQuery.of(context).size.width / 2.2,
        height: 120.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: images[0].image,
            fit: BoxFit.fill,
          ),
        ));
  }
}

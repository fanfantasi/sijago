import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:provider/provider.dart';
import 'package:themify_flutter/themify_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class BannerWidget extends StatefulWidget {
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Loding Banner
  Widget _banner(BannerListViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatusBanner.searching:
        return Container(
            height: MediaQuery.of(context).size.height / 4.7,
            child: Swiper(
                autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            image: AssetImage(
                              'images/no_image.png',
                            ),
                            fit: BoxFit.fitWidth)),
                  );
                },
                itemCount: 3,
                pagination: new SwiperPagination(
                  alignment: Alignment.bottomLeft,
                ),
                control: new SwiperControl(
                  iconNext: Themify.arrow_circle_right,
                  size: 14,
                  iconPrevious: Themify.arrow_circle_left,
                )));
      case LoadingStatusBanner.completed:
        return Container(
          height: MediaQuery.of(context).size.height / 4.7,
          child: Swiper(
            autoplay: true,
            itemBuilder: (BuildContext context, int index) {
              return FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: vs.banner[index].photo,
                fit: BoxFit.fill,
              );
            },
            itemCount: vs.banner?.length ?? 0,
            pagination: new SwiperPagination(
              alignment: Alignment.bottomLeft,
            ),
            control: new SwiperControl(
                iconNext: Themify.arrow_circle_right,
                size: 14,
                iconPrevious: Themify.arrow_circle_left,
                color: Colors.white),
          ),
        );
      case LoadingStatusBanner.empty:
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    var vb = Provider.of<BannerListViewModel>(context);
    return _banner(vb);
  }
}

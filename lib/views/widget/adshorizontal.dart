import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/ads/ads_model.dart';
import 'package:jagomart/views/ads/adsproduk.dart';
import 'package:transparent_image/transparent_image.dart';

class AdsHorizontalWidget extends StatelessWidget {
  final List<AdsViewModel> va;
  AdsHorizontalWidget({Key key, @required this.va}) : super(key: key);

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        '$url',
        option: CustomTabsOption(
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Swiper(
      autoplay: false,
      itemBuilder: (BuildContext context, int i) {
        return InkWell(
            onTap: () {
              if (int.parse(va[i].jenis) == 1) {
                push(
                    context,
                    AdsProdukPage(
                      id: va[i].id,
                      image: va[i].image,
                      distance: va[i].distance,
                      title: va[i].title,
                      phone: va[i].phone,
                    ));
              } else {
                _launchURL(context, va[i].link);
              }
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: va[i].image,
              fit: BoxFit.fill,
            ));
      },
      itemCount: va?.length ?? 0,
    );
  }
}

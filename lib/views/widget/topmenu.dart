import 'package:flutter/material.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/header.dart';
import 'package:jagomart/views/kategori/kategori.dart';
import 'package:jagomart/views/promo/allpromo.dart';
import 'package:themify_flutter/themify_flutter.dart';

import '../maintenance.dart';

class TopMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: jagoRed.withOpacity(0.95),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
      // color: ,
      child: Container(
        padding: const EdgeInsets.only(top: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => MaintenancePage(
                      tag: 'pulsa-maintenance',
                    ),
                  ),
                );
              },
              child: HeaderItem(
                images: Themify.mobile,
                title: 'Pulsa',
                tag: 'pulsa-maintenance',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => AllPromoPage(),
                  ),
                );
              },
              child: HeaderItem(
                images: Themify.tag,
                title: 'Promo',
                tag: 'promo-maintenance',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => MaintenancePage(
                      tag: 'saldo-maintenance',
                    ),
                  ),
                );
              },
              child: HeaderItem(
                images: Themify.wallet,
                title: 'Isi Saldo',
                tag: 'saldo-maintenance',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => KategoriPage(),
                  ),
                );
              },
              child: HeaderItem(
                images: Themify.angle_double_right,
                title: 'Lainnya',
                tag: 'lainnya-maintenance',
              ),
            )
          ],
        ),
      ),
    );
  }
}

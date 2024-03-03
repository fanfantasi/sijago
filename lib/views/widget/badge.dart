import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/helpers/link_helper.dart';
import 'package:jagomart/viewmodels/viewmodels.dart';
import 'package:jagomart/views/cart/cart.dart';
import 'package:provider/provider.dart';
import 'package:themify_flutter/themify_flutter.dart';

class BadgeWidget extends StatefulWidget {
  BadgeWidget({Key key}) : super(key: key);
  @override
  BadgeWidgetState createState() => BadgeWidgetState();
}

class BadgeWidgetState extends State<BadgeWidget> {
  @override
  void initState() {
    Provider.of<CartListViewModel>(context, listen: false).getcart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vb = Provider.of<CartListViewModel>(context);
    vb.getTotalItem();
    return InkWell(
        onTap: () {
          push(context, CartPage());
        },
        child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: (vb.totalItems > 0)
                ? Badge(
                    badgeContent: Text(
                      '${vb.totalItems}',
                      style: GoogleFonts.lato(color: jagoRed),
                    ),
                    child: Icon(Themify.shopping_cart, color: Colors.white),
                    badgeColor: Colors.white,
                    animationDuration: Duration(milliseconds: 200),
                    animationType: BadgeAnimationType.scale,
                  )
                : Icon(
                    Themify.shopping_cart,
                    color: Colors.white,
                  )));
  }
}

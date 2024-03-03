import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jagomart/helpers/app_colors.dart';
import 'package:jagomart/viewmodels/favorit/favorit_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritWidget extends StatelessWidget {
  final FavoritBloc favoritBloc;
  final String itemid;
  FavoritWidget(this.favoritBloc, this.itemid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: favoritBloc.favoritbyidStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return IconButton(
              icon: Icon(
                Icons.favorite,
              ),
              onPressed: () {},
            );
            break;
          default:
            if (snapshot.hasError) {
              return IconButton(
                icon: Icon(
                  Icons.favorite,
                ),
                onPressed: () {},
              );
            }

            if (snapshot.data) {
              return IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: jagoRed,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var token = prefs.getString('token');
                  if (token != null) {
                    favoritBloc.getUnfavoritByid(itemid);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Silahkan login terlebih dahulu",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                        fontSize: 14.0);
                  }
                },
              );
            } else {
              return IconButton(
                icon: Icon(
                  Icons.favorite,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var token = prefs.getString('token');
                  if (token != null) {
                    favoritBloc.getFavoritByid(itemid, true);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Silahkan login terlebih dahulu",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                        fontSize: 14.0);
                  }
                },
              );
            }
        }
      },
    );
  }
}

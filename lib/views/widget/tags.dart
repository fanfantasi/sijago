import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget buildFilter(String name, bool selected) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      border: Border.all(
        width: 1,
        color: Colors.transparent,
      ),
      boxShadow: [
        BoxShadow(
          color: selected
              ? Colors.red[300].withOpacity(0.5)
              : Colors.green[300].withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 0),
        ),
      ],
      color: selected ? Colors.red[300] : Colors.green[300],
    ),
    child: Row(
      children: [
        AutoSizeText(
          name,
          maxLines: 1,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
  );
}

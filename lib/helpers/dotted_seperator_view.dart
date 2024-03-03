import 'package:flutter/material.dart';

class DottedSeperatorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.0,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 80,
        itemBuilder: (context, index) => ClipOval(
          child: Container(
            margin: const EdgeInsets.all(3.0),
            width: 1.0,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ErrorItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "errorText",
          style: Theme.of(context).textTheme.subtitle2,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: RaisedButton(
            child: Text('Retry'),
            padding: const EdgeInsets.all(16),
            onPressed: () {},
            color: const Color(0xff3A3A3A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: const Color(0xffFFAB00),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

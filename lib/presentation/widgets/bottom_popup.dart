import 'package:flutter/material.dart';
import 'package:social_network/utils/constants.dart';

class BottomPopup extends StatelessWidget {
  final Widget child;
  final String title;

  const BottomPopup({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var fullWidth = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: _theme.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        width: fullWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: kDark,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            title != ''
                ? Text(title, style: _theme.textTheme.titleMedium)
                : Container(),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
            ),
            child
          ],
        ),
      ),
    );
  }
}
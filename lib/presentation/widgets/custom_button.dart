import 'package:flutter/material.dart';
import 'package:social_network/utils/constants.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      this.margin,
      this.onPressed,
      this.width,
      this.height,
      this.title,
      this.backgroundColor,
      this.prefixWidget,
      this.suffixWidget});

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onPressed;

  double? width;

  double? height;

  String? title;

  Color? backgroundColor;

  Widget? prefixWidget;

  Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      // padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? kPrimaryColor.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefixWidget ?? const SizedBox.shrink(),
              Text(
                title ?? '',
                style: const TextStyle(
                  color: kDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              suffixWidget ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

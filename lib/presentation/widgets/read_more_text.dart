import 'package:flutter/material.dart';
import 'package:social_network/utils/utils.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLength;

  const ReadMoreText({
    Key? key,
    required this.text,
    this.trimLength = 200,
  }) : super(key: key);

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isTextLong = widget.text.length > widget.trimLength;
    final displayText = isExpanded || !isTextLong
        ? widget.text
        : '${widget.text.substring(0, widget.trimLength)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: const TextStyle(fontSize: 16),
        ),
        if (isTextLong)
          Container(
            // decoration: BoxDecoration(
            //   boxShadow: [
            //     BoxShadow(
            //       color: kSecondaryLightColor.withOpacity(0.3),
            //       spreadRadius: 1,
            //       blurRadius: 5,
            //       offset: const Offset(0, 5),
            //     ),
            //   ],
            // ),
            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Thu gọn' : 'Xem Thêm',
                  style: const TextStyle(color: kSecondaryColor),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

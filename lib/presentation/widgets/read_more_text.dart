import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLength;

  const ReadMoreText({
    Key? key,
    required this.text,
    this.trimLength = 100,
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
        Text(displayText),
        if (isTextLong)
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(isExpanded ? 'Thu gọn' : 'Xem Thêm'),
            ),
          ),
      ],
    );
  }
}

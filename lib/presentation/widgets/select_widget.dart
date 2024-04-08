import 'package:flutter/material.dart';
import 'package:social_network/utils/constants.dart';

class SelectWidget extends StatefulWidget {
  final String text;
  final Function? onChanged;
  final bool isSelect;
  const SelectWidget(
      {super.key, required this.text, this.onChanged, required this.isSelect});

  @override
  State<SelectWidget> createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: InkWell(
        onTap: () {
          widget.onChanged!();
        },
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelect! ? kSecondaryColor : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: widget.isSelect! ? kSecondaryColor : Colors.grey,
              width: 1,
            ),
          ),
          child: Text(
            widget.text,
            style: theme.textTheme.titleMedium!.copyWith(
              color: widget.isSelect! ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

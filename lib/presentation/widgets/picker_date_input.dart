import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/utils/text_format.dart';

class PickerDateInput extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final BuildContext context;
  PickerDateInput(this.context, {super.key, required this.onDateSelected});

  @override
  State<PickerDateInput> createState() => _PickerDateInputState();
}

class _PickerDateInputState extends State<PickerDateInput> {
  final _dateController = TextEditingController();
  DateTime _dates = DateTime.now();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: 'Ngày sinh',
      controller: _dateController,
      textInputType: TextInputType.datetime,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập ngày sinh';
        }
        return null;
      },
      suffix: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () {
          showDatePicker(
            context: widget.context,
            // locale: const Locale('vi', 'VN'),
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2050),
          ).then((value) {
            if (value != null) {
              widget.onDateSelected(value);
              setState(() {
                _dates = value;
                _dateController.text = TextFormat.formatDate(value);
              });
            }
          });
        },
      ),
    );
  }
}

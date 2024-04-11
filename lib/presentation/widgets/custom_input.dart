import 'package:flutter/material.dart';
import 'package:social_network/utils/constants.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      this.alignment,
      this.width,
      this.margin,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.validator,
      this.errorText,
      this.onChanged,
      this.controller,
      this.onFieldSubmitted,
      this.focusNode,
      this.nextFocusNode});

  Alignment? alignment;
  double? width;
  EdgeInsetsGeometry? margin;
  Function(String)? onFieldSubmitted;
  Function(String)? onChanged;
  bool? isObscureText;
  TextInputAction? textInputAction;
  TextInputType? textInputType;
  int? maxLines;
  String? hintText;
  Widget? prefix;
  BoxConstraints? prefixConstraints;
  Widget? suffix;
  BoxConstraints? suffixConstraints;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  String? errorText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.infinity,
      margin: margin ?? const EdgeInsets.only(left: 20, right: 20, top: 4),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onFieldSubmitted: (_) => onFieldSubmitted,
        onChanged: (value) => onChanged!(value),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          // color red when validate error
          color: kOfWhite,
          width: 1,
        ),
      ),
      labelText: hintText ?? "",
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      errorText: errorText,
    );
  }
}

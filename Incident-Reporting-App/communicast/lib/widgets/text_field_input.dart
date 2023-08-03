import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communicast/constants.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    required this.textCapitalization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      textCapitalization: textCapitalization,
      style: AppTextStyles.textFields,
      decoration: InputDecoration(
        fillColor: AppColors.greyAccent,
        hintText: hintText,
        hintStyle: AppTextStyles.subHeadings,
        border: InputBorder.none,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.transparent, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}

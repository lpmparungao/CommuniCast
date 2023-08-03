import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communicast/constants.dart';

class TextFieldEdit extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  const TextFieldEdit({
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
      style: AppTextStyles.body,
      decoration: InputDecoration(
        fillColor: AppColors.greyAccent,
        hintText: hintText,
        hintStyle: AppTextStyles.subHeadings,
        border: InputBorder.none,
        focusedBorder: const UnderlineInputBorder(
          //borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: AppColors.blueAccent, width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.black),
          // borderRadius: BorderRadius.all(
          //   Radius.circular(10.0),
          // ),
        ),
        //filled: true,
        contentPadding: const EdgeInsets.all(0),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}

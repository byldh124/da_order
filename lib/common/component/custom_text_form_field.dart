import 'package:da_order/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final String? initialValue;

  const CustomTextFormField({
    super.key,
    required this.onChanged,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autoFocus = false,
    this.initialValue
  });

  @override
  Widget build(BuildContext context) {
    // UnderlineInputBorder - 기본 적용
    final baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: INPUT_BORDER_COLOR,
      width: 1.0,
    ));

    return TextFormField(
        cursorColor: PRIMARY_COLOR,
        //비밀번호 입력할때
        obscureText: obscureText,
        initialValue: initialValue,
        //화면진입시 자동 포커스상태
        autofocus: autoFocus,
        //값이 바뀔때
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: hintText,
          hintStyle: TextStyle(
            color: BODY_TEXT_COLOR,
            fontSize: 14.0,
          ),
          errorText: errorText,
          fillColor: INPUT_BG_COLOR,
          //filled : false - 배경색 없음
          //filled : true - 배경색 있음
          filled: true,
          // 모든 Input 상태의 기본 스타일 세팅
          border: baseBorder,
          enabledBorder: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(
              color: PRIMARY_COLOR,
            ),
          ),
        ));
  }
}

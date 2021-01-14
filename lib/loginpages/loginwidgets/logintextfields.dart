import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostelfinder/utils/colorutils/colorutils.dart';
import 'package:hostelfinder/utils/sizingutil/sizingutil.dart';

typedef String CustomValidator(String val);

class LoginTextFields extends StatelessWidget {
  LoginTextFields({
    Key key,
    this.hintText,
    this.tec,
    this.multiValidator,
    this.obsecureText = false,
    this.showEye = false,
    this.onEyeTap,
  }) : super(key: key);
  final String hintText;
  final TextEditingController tec;
  final MultiValidator multiValidator;
  final bool obsecureText;
  final bool showEye;
  final VoidCallback onEyeTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(SizingUtil.TEXTFIELD_BORDER_RADIUS),
        ),
        color: ColorUtils.WHITE_COLOR,
        shadowColor: ColorUtils.SHADOW_COLOR,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  obscureText: obsecureText ?? false,
                  validator: multiValidator,
                  cursorColor: ColorUtils.YELLOW_COLOR,
                  style: GoogleFonts.sourceSansPro(
                      color: ColorUtils.HEADING_BLACK, fontSize: 18),
                  controller: tec,
                  decoration: InputDecoration(
                      hintText: '$hintText',
                      hintStyle: GoogleFonts.sourceSansPro(
                          color: ColorUtils.HEADING_GREY, fontSize: 18),
                      contentPadding: EdgeInsets.only(left: 8),
                      border: InputBorder.none),
                ),
              ),
              showEye
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                          onTap: onEyeTap,
                          child: obsecureText
                              ? Icon(Icons.remove_red_eye)
                              : Icon(
                                  Icons.remove_red_eye,
                                  color: ColorUtils.YELLOW_COLOR,
                                )),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

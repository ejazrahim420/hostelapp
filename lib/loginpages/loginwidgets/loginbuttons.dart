import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hostelfinder/utils/sizingutil/sizingutil.dart';

class LoginButtons extends StatelessWidget {
  LoginButtons(
      {Key key,
      this.constraints,
      this.backgroundColor,
      this.text,
      this.textColor,
      this.buttonPressed})
      : super(key: key);
  final BoxConstraints constraints;
  final Color backgroundColor;
  final String text;
  final Color textColor;
  final VoidCallback buttonPressed;
  @override
  Widget build(BuildContext context) {
    print(constraints.maxHeight);
    return UnconstrainedBox(
      child: MaterialButton(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizingUtil.BUTTON_BORDER_RADIUS),
        ),
        color: backgroundColor,
        minWidth: constraints.maxWidth,
        height: constraints.maxHeight > SizingUtil.BUTTON_HEIGHTS_LOGIN
            ? SizingUtil.BUTTON_HEIGHTS_LOGIN
            : constraints.maxHeight,
        onPressed: buttonPressed,
        child: Text('$text',
            style: GoogleFonts.openSans(
                color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

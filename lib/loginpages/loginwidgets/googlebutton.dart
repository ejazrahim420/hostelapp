import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostelfinder/utils/colorutils/colorutils.dart';
import 'package:hostelfinder/utils/sizingutil/sizingutil.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key key, this.constraints, this.onGoogleButtonPressed})
      : super(key: key);
  final BoxConstraints constraints;
  final VoidCallback onGoogleButtonPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGoogleButtonPressed,
      child: UnconstrainedBox(
        child: SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight > SizingUtil.BUTTON_HEIGHTS
              ? SizingUtil.BUTTON_HEIGHTS
              : constraints.maxHeight - 5,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(SizingUtil.BUTTON_BORDER_RADIUS),
              ),
            ),
            elevation: 2,
            shadowColor: ColorUtils.HEADING_GREY,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, top: 10.0, bottom: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Image.asset(
                      'assets/googleicon.png',
                    ),
                  ),
                  Text(
                    'Sign in with Google',
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

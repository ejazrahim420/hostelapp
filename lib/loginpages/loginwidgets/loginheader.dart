import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostelfinder/utils/colorutils/colorutils.dart';
import 'package:hostelfinder/utils/sizingutil/sizingutil.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader(
      {Key key,
      this.titleText,
      this.onRegisterPressed,
      this.onBackIconPressed,
      this.isSignUpPage = false})
      : super(key: key);
  final String titleText;
  final VoidCallback onBackIconPressed;
  final VoidCallback onRegisterPressed;
  final bool isSignUpPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  CupertinoIcons.arrow_left,
                  color: ColorUtils.HEADING_BLACK,
                ),
                onPressed: onBackIconPressed,
              ),
              !isSignUpPage
                  ? Padding(
                      padding: const EdgeInsets.only(
                          right: SizingUtil.headerOneHorizantalPadding),
                      child: GestureDetector(
                        onTap: onRegisterPressed,
                        child: Text(
                          'Register',
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.BLACK_COLOR,
                              fontSize: 16),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
        Spacer(
          flex: 30,
        ),
        Expanded(
          flex: 40,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                '$titleText',
                style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.HEADING_BLACK,
                    fontSize: 26),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

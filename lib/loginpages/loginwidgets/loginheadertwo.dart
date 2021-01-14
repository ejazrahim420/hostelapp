import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostelfinder/utils/colorutils/colorutils.dart';

class LoginHeaderTwo extends StatelessWidget {
  const LoginHeaderTwo({Key key, this.onGoogleButtonPressed}) : super(key: key);
  final VoidCallback onGoogleButtonPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Chosse an Option to access',
          style: GoogleFonts.sourceSansPro(
              color: ColorUtils.HEADING_GREY, fontSize: 18),
        ),
        Text(
          'Hostel',
          style: GoogleFonts.sourceSansPro(
              color: ColorUtils.HEADING_GREY, fontSize: 18),
        ),
        SizedBox(
          height: 12,
        ),
        InkWell(
          onTap: onGoogleButtonPressed,
          child: Card(
            elevation: 3,
            shadowColor: ColorUtils.HEADING_GREY,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, top: 10.0, bottom: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Icon(Icons.ac_unit),
                  ),
                  Text(
                    'Sign in with Google',
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        fontSize: 14),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          'or log in with e-mail',
          style: GoogleFonts.sourceSansPro(
              color: ColorUtils.HEADING_GREY, fontSize: 18),
        ),
      ],
    );
  }
}

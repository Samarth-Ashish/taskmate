import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Shader appBarTextGradient = LinearGradient(
  colors: <Color>[
    const Color.fromARGB(255, 111, 190, 255),
    const Color.fromARGB(255, 0, 62, 113),
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

Text lobsterAppBarText(String string) {
  return Text(
    string,
    style: GoogleFonts.lobster(
      fontSize: 40,
      foreground: Paint()..shader = appBarTextGradient,
      shadows: [
        Shadow(
          color: Colors.grey.shade500,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    ),
  );
}

Text lilitaOneAddText() {
  return Text(
    'Add',
    style: GoogleFonts.lilitaOne(
      fontSize: 18,
      color: const Color.fromARGB(255, 0, 68, 170),
    ),
  );
}

Text manjari(
  String string, {
  double fontSize = 30,
  FontWeight fontWeight = FontWeight.w900,
  Color color = const Color.fromARGB(255, 0, 113, 170),
}) {
  return Text(
    string,
    style: GoogleFonts.manjari(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}

Text manjariSmall(
  String string, {
  double fontSize = 20,
  FontWeight fontWeight = FontWeight.normal,
  Color color = const Color.fromARGB(255, 0, 113, 170),
}) {
  return Text(
    string,
    style: GoogleFonts.manjari(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}

Text manjariExtraSmall(
  String string, {
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.normal,
  Color color = const Color.fromARGB(255, 0, 113, 170),
}) {
  return Text(
    string,
    style: GoogleFonts.manjari(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}

Text mada(
  String string, {
  double fontSize = 30,
  FontWeight fontWeight = FontWeight.w500,
  Color color = const Color.fromARGB(255, 5, 131, 195),
}) {
  return Text(
    string,
    style: GoogleFonts.mada(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}

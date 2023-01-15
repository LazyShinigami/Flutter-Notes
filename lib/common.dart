import 'package:flutter/material.dart';

//
// TEXT
//
class myText extends StatelessWidget {
  double? _fontSize;
  double? _height;
  double? _wordSpacing;
  double? _letterSpace;
  Color? _fontColor;
  String? _content;
  FontWeight? _fontWeight = FontWeight.normal;

  var colors = ColorPallete();

  myText(this._content,
      {super.key,
      double? size = 18,
      Color? color,
      double? spacing = 0,
      FontWeight? weight,
      double? height = 0,
      double? wordSpacing = 0}) {
    color ??= colors._purplePallete[800]!;
    _fontSize = size;
    _fontColor = color;
    _letterSpace = spacing;
    _fontWeight = weight;
    _height = height;
    _wordSpacing = wordSpacing;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _content.toString(),
      style: TextStyle(
        color: _fontColor,
        fontSize: _fontSize,
        letterSpacing: _letterSpace,
        fontWeight: _fontWeight,
        height: _height,
        wordSpacing: _wordSpacing,
        fontFamily: 'HindSiliguri',
      ),
    );
  }
}

//
// Color Pallete
//
class ColorPallete {
  // https://www.youtube.com/watch?v=yYwEnLYT55c
  final Map<int, Color> _purplePallete = {
    100: const Color(0xFFF7F1FF),
    200: const Color(0xffcdaefa),
    300: const Color(0xffb384f5),
    400: const Color(0xff9057e0),
    500: const Color(0xff7133c7),
    600: const Color(0xff5820a7),
    700: const Color(0xff401183),
    800: const Color(0xff2c085e),
    900: const Color(0xff1a023b),
  };
  Map<int, Color> get purplePallete {
    return _purplePallete;
  }

  final Map<int, Color> _neutralPallete = {
    100: const Color(0xffe3e2e4),
    200: const Color(0xffbcbabf),
    300: const Color(0xff98949e),
    400: const Color(0xff77727e),
    500: const Color(0xff534e5a),
    600: const Color(0xff413c49),
    700: const Color(0xff2f2a37),
    800: const Color(0xff201c26),
    900: const Color(0xff1b1622),
  };
  Map<int, Color> get neutralPallete {
    return _neutralPallete;
  }

  final Map<String, Color> _messagePallet = {
    'errorMessage': Colors.red,
    'errorBackground': Color.fromARGB(21, 249, 113, 104),
    'warningMessage': Colors.orange,
    'warningBackground': Color(0x4DFF9900),
    'infoMessage': Colors.blue,
    'infoBackground': Color(0x4E2195F3),
    'validMessage': Colors.green,
    'validBackground': Color(0x434CAF4F),
  };
  Map<String, Color> get messagePallet {
    return _messagePallet;
  }
}

class MyTextField extends StatelessWidget {
  String hintText;
  myText label;
  TextEditingController controller;
  double height;
  bool obscureText;
  MyTextField(
      {required this.label,
      required this.controller,
      this.hintText = "",
      this.height = 55,
      this.obscureText = false,
      super.key});

  var colors = ColorPallete();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 4, 2, 4),
      // height: height,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: colors._purplePallete[700]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(color: colors.purplePallete[700], fontSize: 18),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
          label: label,
        ),
      ),
    );
  }
}

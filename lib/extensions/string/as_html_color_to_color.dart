// convert 0x?????? or #?????? to color
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/extensions/string/remove_all.dart';

extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['0x', '#']).padLeft(8, 'ff'),
          radix: 16,
        ),
      );
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetron/logic/category/category_service.dart';

void main() {
  group('Convert Color to String and back to Color', () {
    test('Properly converts static Color values back and forth', () {
      const Color color1 = Colors.white;
      expect(
          CategoryService.stringToColor(CategoryService.colorToString(color1))
              .value,
          color1.value);

      const Color color2 = Colors.black;
      expect(
          CategoryService.stringToColor(CategoryService.colorToString(color2))
              .value,
          color2.value);

      const Color color3 = Colors.amber;
      expect(
          CategoryService.stringToColor(CategoryService.colorToString(color3))
              .value,
          color3.value);

      const Color color4 = Colors.indigoAccent;
      expect(
          CategoryService.stringToColor(CategoryService.colorToString(color4))
              .value,
          color4.value);

      const Color color5 = Colors.deepOrangeAccent;
      expect(
          CategoryService.stringToColor(CategoryService.colorToString(color5))
              .value,
          color5.value);

      const Color color6 = Colors.brown;
      expect(
          CategoryService.stringToColor(CategoryService.colorToString(color6))
              .value,
          color6.value);

      const Color color7 = Colors.deepPurple;
      expect(
          CategoryService.stringToColor(CategoryService.colorToString(color7))
              .value,
          color7.value);

      const Color color8 = Colors.lightGreen;
      expect(
          CategoryService.stringToColor(CategoryService.colorToString(color8))
              .value,
          color8.value);

      const Color color9 = Colors.pink;
      expect(
          CategoryService.stringToColor(CategoryService.colorToString(color9))
              .value,
          color9.value);
    });

    test('Properly converts randomly generated Colors back and forth', () {
      for (int i = 0; i < 100; i++) {
        Color color =
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
        expect(
            CategoryService.stringToColor(CategoryService.colorToString(color))
                .value,
            color.value);
      }
    });
  });
}

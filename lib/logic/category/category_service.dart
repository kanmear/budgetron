import 'dart:ui';

class CategoryService {
  static String colorToString(Color color) {
    return 'ff${color.value.toRadixString(16).substring(2)}';
  }

  static Color stringToColor(String string) {
    return Color(int.parse(
      string,
      radix: 16,
    ));
  }
}

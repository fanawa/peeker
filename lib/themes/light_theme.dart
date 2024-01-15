import 'package:flutter/material.dart';

Color primaryColor = const Color.fromRGBO(152, 121, 72, 1);
Color lightPrimaryColor = const Color.fromRGBO(245, 240, 234, 1);
Color primaryColorLight = const Color.fromRGBO(152, 121, 72, 1);
Color menuTileColor = const Color.fromRGBO(177, 141, 83, 1);
Color menuItemBorderColor = const Color.fromRGBO(193, 163, 115, 1);
Color menuLabelColor = const Color.fromRGBO(152, 121, 72, 1);
Color menuTrailingColor = const Color.fromRGBO(233, 226, 215, 1);
Color primaryThinColor = const Color.fromRGBO(234, 217, 191, 1);
Color mainBackGroundColor = const Color.fromRGBO(232, 232, 232, 1);
Color appBarMenuColor = const Color.fromRGBO(144, 144, 144, 1);
Color accentColor = const Color.fromRGBO(0xF3, 0xF5, 0xFA, 1);
Color primaryTextColor = const Color.fromRGBO(0x3E, 0x3E, 0x3E, 1);
Color accentTextColor = const Color.fromRGBO(0x70, 0x70, 0x70, 1);
Color bottomNavigationBackgroundColor =
    const Color.fromRGBO(0x00, 0x00, 0x00, 1);
Color unselectBottomNavigationBarColor =
    const Color.fromRGBO(0x6E, 0x6E, 0x6E, 1);
Color backgroundColor = const Color.fromRGBO(255, 255, 255, 1);
Color disabledColor = const Color.fromRGBO(0xC4, 0xC4, 0xC4, 1);
Color errorMessageColor = const Color.fromRGBO(205, 42, 42, 1);

const double appBarHeight = 70.0;
const double baseHorizontalPaddingRate = 0.025;
const double calendarCellWithRate = 1;
const double calendarCellHeightRate = 1.35;
const double calendarCellAspectRatio =
    calendarCellWithRate / calendarCellHeightRate;
// AppBarタイトルテキスト
TextStyle appBarTitleStyle = TextStyle(
  color: primaryColor,
);

// AppBarアイコンラベルキスト
TextStyle appBarIconLabelStyle = TextStyle(
  color: appBarMenuColor,
  fontSize: 9.0,
);

TextStyle appBarIconActiveLabelStyle = TextStyle(
  color: primaryColor,
  fontSize: 9.0,
);

ThemeData getLightTheme(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  return ThemeData(
    primaryColor: primaryColor,
    colorScheme: theme.colorScheme.copyWith(
      secondary: accentColor,
    ),
    fontFamily: 'NotoSansJP',
    scaffoldBackgroundColor: mainBackGroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: true,
      toolbarHeight: 60,
      titleTextStyle: TextStyle(
        color: accentColor,
        fontSize: 16,
        fontFamily: 'NotoSansJP',
      ),
      actionsIconTheme: IconThemeData(
        color: primaryColor,
      ),
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(primaryColor),
      fillColor: MaterialStateProperty.all(Colors.white),
      side: MaterialStateBorderSide.resolveWith(
        (_) => const BorderSide(
          color: Colors.black54,
          width: 0.5,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor, iconSize: 20),
    primaryIconTheme: theme.primaryIconTheme.copyWith(
      color: primaryColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      selectedItemColor: primaryColor,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      showUnselectedLabels: true,
      unselectedItemColor: unselectBottomNavigationBarColor,
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: 'NotoSansJP',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          textStyle: const TextStyle(
            fontFamily: 'NotoSansJP',
          )),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(
          color: Colors.white,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'NotoSansJP',
        ),
        backgroundColor: primaryColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
    ),
  );
}

// * Themes app
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sap_avicola/main_provider.dart';
import 'package:sap_avicola/utils/general/context_utility.dart';

///? A Collection of app themes.
enum ThemeType {
  light,
  dark;
}

///? A Class to get some weigth of current font families.
/// use like `FontFamily.noto("400")`
class FontFamily {
  static final _conversion = {
    "100": "extra_light",
    "200": "semi_light",
    "300": "light",
    "400": "regular",
    "500": "medium",
    "600": "semi_bold",
    "700": "bold",
    "800": "extra_bold",
    "900": "black",
  };

  static String noto(String value) => 'NotoSans_${_conversion[value] ?? value}';
}

/// Themes configuration class from app.
class ThemeApp {
  static SystemUiOverlayStyle get systemUiOverlayStyle =>
      theme == ThemeType.light
          ? const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              systemStatusBarContrastEnforced: true,
              systemNavigationBarIconBrightness: Brightness.light,
            )
          : const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              systemStatusBarContrastEnforced: true,
              systemNavigationBarIconBrightness: Brightness.dark,
            );

  static T _getExtension<T>(Map<Object, ThemeExtension<dynamic>> extensions) =>
      extensions[T] as T;

  static Map<ThemeType, ThemeData> get _themes {
    //? light
    final lightExtensions = <Object, ThemeExtension<dynamic>>{
      ThemeDataColorExtension: const ThemeDataColorExtension(
        text: Color(0xFF4E444B),
        label: Color(0xFF777680),
        title: Color(0xFF4E444B),
        accent: Color(0xff798c77),
        accentVariant: Color(0xffa68a5b),
        success: Color(0xff75980b),
        warning: Color(0xFFFFDD00),
        primaryLighten: Color(0xff84b8eb),
        primaryDarken: Color(0xff19334e),
        secondaryLighten: Color(0xffeaadad),
        tertiaryDarken: Color(0xff623c00),
      ),
      ThemeDataStyleExtension: const ThemeDataStyleExtension(
        customText: TextStyle(),
      )
    };

    var ligthTheme = ThemeData(
        fontFamily: "72Font",
        useMaterial3: true,
        // values config
        visualDensity: VisualDensity.compact,
        // color config
        primaryColor: const Color(0xff3278be),
        focusColor: const Color(0xFF3B4279),
        disabledColor: const Color.fromARGB(255, 209, 175, 172),
        cardColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xfffafafa),
        colorScheme: const ColorScheme.light(
          background: Color(0xFFF9F9F9),
          primary: Color(0xff3278be),
          secondary: Color(0xffda6c6c),
          tertiary: Color(0xffc87b00),
          error: Color(0xffdf1278),
          outline: Color(0xFF4E444B),
        ),
        extensions: lightExtensions.values,
        // dividerTheme
        dividerTheme: const DividerThemeData(color: Color(0xFF4E444B)),
        // appBarTheme
        appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xfffafafa),
            titleTextStyle: TextStyle(
              fontSize: 17,
              color: _getExtension<ThemeDataColorExtension>(lightExtensions)
                  .title!,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              height: 1.1,
            )),
        // bottomNavigationBarTheme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
        // dialogTheme
        dialogTheme: DialogTheme(
            backgroundColor: const Color(0xfff5f6f7),
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: _getExtension<ThemeDataColorExtension>(lightExtensions)
                  .title!,
              height: 1.1,
            ),
            contentTextStyle: TextStyle(
              fontSize: 16,
              color:
                  _getExtension<ThemeDataColorExtension>(lightExtensions).text!,
              height: 1.1,
            )),
        // bottomSheetTheme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        // datePickerTheme
        datePickerTheme: const DatePickerThemeData(
          headerBackgroundColor: Color(0xff198eff),
          headerForegroundColor: Colors.white,
          dayForegroundColor: MaterialStatePropertyAll(Color(0xFF535256)),
          weekdayStyle: TextStyle(color: Color(0xff198eff)),
          dayStyle: TextStyle(fontWeight: FontWeight.w400),
          cancelButtonStyle: ButtonStyle(
            textStyle: MaterialStatePropertyAll(
              TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          confirmButtonStyle: ButtonStyle(
            textStyle: MaterialStatePropertyAll(
              TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        // timePickerTheme
        timePickerTheme: const TimePickerThemeData(
          // TODO troubles with color scheme here
          // hourMinuteColor: Color(0xFFC7C5D0),
          // hourMinuteTextColor: Color(0xFF3B4279),
          // dayPeriodColor: Color(0xFFC7C5D0),
          // dayPeriodTextColor: Color(0xFF3B4279),
          // dialBackgroundColor: Color(0xFFC7C5D0),
          // dialHandColor: Color(0xFF3B4279),
          cancelButtonStyle: ButtonStyle(
            textStyle: MaterialStatePropertyAll(
              TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          confirmButtonStyle: ButtonStyle(
            textStyle: MaterialStatePropertyAll(
              TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        // inputDecorationTheme
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xffffffff),
          outlineBorder: BorderSide(color: Color(0xFF46464F)),
        ),
        // progressIndicatorTheme
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          circularTrackColor: Colors.red,
          color: Color(0xff198eff),
        ),

        // text config
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: 17,
            color:
                _getExtension<ThemeDataColorExtension>(lightExtensions).title!,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.15,
            height: 1.1,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color:
                _getExtension<ThemeDataColorExtension>(lightExtensions).text!,
            height: 1.1,
          ),
          bodySmall: TextStyle(
            color:
                _getExtension<ThemeDataColorExtension>(lightExtensions).text!,
            height: 1.1,
          ),
        ));

    //? dark
    var darkTheme = ThemeData(
      fontFamily: "72Font",
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(),
    );

    return {
      ThemeType.light: ligthTheme,
      ThemeType.dark: darkTheme,
    };
  }

  ///* Getter to current theme name.
  static ThemeType get theme =>
      ContextUtility.context?.watch<MainProvider>().appTheme ?? ThemeType.light;

  ///* Getter to current theme assets directory `assets/themes/${theme}/` + path provided.
  static String getAsset(BuildContext? context, String path) =>
      'assets/themes/${(context ?? ContextUtility.context!).watch<MainProvider>().appTheme.name}/$path';

  ///* Getter to current themeData.
  static ThemeData of(BuildContext? context) {
    final ctx = context ?? ContextUtility.context!;
    return _themes[ctx.watch<MainProvider>().appTheme]!;
  }

  ///* Switch between themeData.
  static void switchTheme(BuildContext? context, ThemeType themeType) =>
      (context ?? ContextUtility.context!).read<MainProvider>().switchTheme =
          themeType;

  ///* Getter to all custom colors registered in themeData.
  static ColorsApp colors(BuildContext? context) {
    final themeData = Theme.of(context ?? ContextUtility.context!);

    return ColorsApp(
      background: themeData.colorScheme.background,
      primary: themeData.colorScheme.primary,
      secondary: themeData.colorScheme.secondary,
      tertiary: themeData.colorScheme.tertiary,
      error: themeData.colorScheme.error,
      focusColor: themeData.focusColor,
      disabledColor: themeData.disabledColor,
      text: themeData.extension<ThemeDataColorExtension>()!.text!,
      label: themeData.extension<ThemeDataColorExtension>()!.label!,
      title: themeData.extension<ThemeDataColorExtension>()!.title!,
      accent: themeData.extension<ThemeDataColorExtension>()!.accent!,
      accentVariant:
          themeData.extension<ThemeDataColorExtension>()!.accentVariant!,
      success: themeData.extension<ThemeDataColorExtension>()!.success!,
      warning: themeData.extension<ThemeDataColorExtension>()!.warning!,
      primaryLighten:
          themeData.extension<ThemeDataColorExtension>()!.primaryLighten!,
      primaryDarken:
          themeData.extension<ThemeDataColorExtension>()!.primaryDarken!,
      secondaryLighten:
          themeData.extension<ThemeDataColorExtension>()!.secondaryLighten!,
      tertiaryDarken:
          themeData.extension<ThemeDataColorExtension>()!.tertiaryDarken!,
    );
  }

  ///* Getter to all custom styles registered in themeData.
  static ThemeDataStyleExtension styles(BuildContext? context) {
    final themeData = Theme.of(context ?? ContextUtility.context!);

    return ThemeDataStyleExtension(
      customText: themeData.extension<ThemeDataStyleExtension>()!.customText,
    );
  }
}

///? Collection of all custom colors registered in themeData
class ColorsApp {
  const ColorsApp({
    required this.background,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.focusColor,
    required this.disabledColor,
    required this.text,
    required this.label,
    required this.title,
    required this.accent,
    required this.accentVariant,
    required this.success,
    required this.warning,
    required this.primaryLighten,
    required this.primaryDarken,
    required this.secondaryLighten,
    required this.tertiaryDarken,
  });
  final Color background;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color error;
  final Color focusColor;
  final Color disabledColor;
  final Color text;
  final Color label;
  final Color title;
  final Color accent;
  final Color accentVariant;
  final Color success;
  final Color warning;
  final Color primaryLighten;
  final Color primaryDarken;
  final Color secondaryLighten;
  final Color tertiaryDarken;
}

// ? Theme data color extension
@immutable
class ThemeDataColorExtension extends ThemeExtension<ThemeDataColorExtension> {
  const ThemeDataColorExtension({
    this.text,
    this.label,
    this.title,
    this.accent,
    this.accentVariant,
    this.success,
    this.warning,
    this.primaryLighten,
    this.primaryDarken,
    this.secondaryLighten,
    this.tertiaryDarken,
  });
  final Color? text;
  final Color? label;
  final Color? title;
  final Color? accent;
  final Color? accentVariant;
  final Color? success;
  final Color? warning;
  final Color? primaryLighten;
  final Color? primaryDarken;
  final Color? secondaryLighten;
  final Color? tertiaryDarken;

  @override
  ThemeDataColorExtension copyWith({
    Color? text,
    Color? label,
    Color? title,
    Color? accent,
    Color? accentVariant,
    Color? success,
    Color? warning,
    Color? primaryLighten,
    Color? primaryDarken,
    Color? secondaryLighten,
    Color? tertiaryDarken,
  }) {
    return ThemeDataColorExtension(
      text: text ?? this.text,
      label: label ?? this.label,
      title: title ?? this.title,
      accent: accent ?? this.accent,
      accentVariant: accentVariant ?? this.accentVariant,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      primaryLighten: primaryLighten ?? this.primaryLighten,
      primaryDarken: primaryDarken ?? this.primaryDarken,
      secondaryLighten: secondaryLighten ?? this.secondaryLighten,
      tertiaryDarken: tertiaryDarken ?? this.tertiaryDarken,
    );
  }

  @override
  ThemeDataColorExtension lerp(ThemeDataColorExtension? other, double t) {
    if (other is! ThemeDataColorExtension) return this;

    return ThemeDataColorExtension(
      text: Color.lerp(text, other.text, t),
      label: Color.lerp(label, other.label, t),
      title: Color.lerp(title, other.title, t),
      accent: Color.lerp(accent, other.accent, t),
      accentVariant: Color.lerp(accentVariant, other.accentVariant, t),
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      primaryLighten: Color.lerp(primaryLighten, other.primaryLighten, t),
      primaryDarken: Color.lerp(primaryDarken, other.primaryDarken, t),
      secondaryLighten: Color.lerp(secondaryLighten, other.secondaryLighten, t),
      tertiaryDarken: Color.lerp(tertiaryDarken, other.tertiaryDarken, t),
    );
  }

  @override
  String toString() =>
      'ThemeDataColorExtension(text: $text, label: $label, title: $title, accent: $accent, accentVariant: $accentVariant, success: $success, warning: $warning, primaryLighten: $primaryLighten, primaryDarken: $primaryDarken, secondaryLighten: $secondaryLighten, tertiaryDarken: $tertiaryDarken)';
}

// ? Theme data style extension
@immutable
class ThemeDataStyleExtension extends ThemeExtension<ThemeDataStyleExtension> {
  const ThemeDataStyleExtension({
    required this.customText,
  });
  final TextStyle customText;

  @override
  ThemeDataStyleExtension copyWith({
    TextStyle? customText,
  }) {
    return ThemeDataStyleExtension(
      customText: customText ?? this.customText,
    );
  }

  @override
  ThemeDataStyleExtension lerp(ThemeDataStyleExtension? other, double t) {
    if (other is! ThemeDataStyleExtension) return this;

    return const ThemeDataStyleExtension(
      customText: TextStyle(),
    );
  }

  @override
  String toString() => 'ThemeDataStyleExtension(customText: $customText)';
}

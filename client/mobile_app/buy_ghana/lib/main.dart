import 'package:flutter/material.dart';
//
// void main() {
//   print('App is running');
//   runApp(const BuyGhanaMain());
// }
//
// class BuyGhanaMain extends StatelessWidget {
//   const BuyGhanaMain({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = ThemeData(
//       colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.lightThemePrimaryColor),
//       // fontFamily: 'Montserrat',  // TODO: change to Switzer
//       scaffoldBackgroundColor: CustomColors.lightThemeTintStockColor,
//       appBarTheme: const AppBarTheme(
//         backgroundColor: CustomColors.lightThemeTintStockColor,
//         elevation: 0,
//         foregroundColor: CustomColors.lightThemePrimaryTextColor,
//       ),
// useMaterial3: true,
//     );
//     return  MaterialApp(
//       theme: theme,
//       darkTheme: theme.copyWith(
//         scaffoldBackgroundColor: CustomColors.darkThemeDarkBGDark,
//         appBarTheme: AppBarTheme(
//           backgroundColor: CustomColors.darkThemeDarkBGDark,
//           elevation: 0,
//           foregroundColor: CustomColors.lightThemeWhiteColor,
//         ),
//       ),
//       title: 'Buy Ghana',
//       themeMode: ThemeMode.system,
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello'),
//         ),
//       ),
//     );
//   }
// }

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text('Hello'),
      ),
    ),
  ));
}

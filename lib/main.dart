import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetomobile/pages/login.dart';
import 'package:projetomobile/pages/home_page.dart';
import 'package:projetomobile/utils/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar barras do sistema para evitar áreas acinzentadas
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.darkBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const MovieDexApp());
}

class MovieDexApp extends StatelessWidget {
  const MovieDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieDex',
      theme: ThemeData(
        // Tema personalizado baseado na paleta Netflix
        primarySwatch: MaterialColor(
          0xFFE50914,
          const <int, Color>{
            50: Color(0xFFFFEBEE),
            100: Color(0xFFFFCDD2),
            200: Color(0xFFEF9A9A),
            300: Color(0xFFE57373),
            400: Color(0xFFEF5350),
            500: Color(0xFFE50914), // Netflix Red
            600: Color(0xFFE53935),
            700: Color(0xFFD32F2F),
            800: Color(0xFFC62828),
            900: Color(0xFFB71C1C),
          },
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.netflixRed,
          secondary: AppColors.netflixRed,
          surface: AppColors.lightBackground,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.white),
          bodyMedium: TextStyle(color: AppColors.white),
          bodySmall: TextStyle(color: AppColors.lightGray),
        ),
        // Configurações para inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.inputBorderFocused, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryButton,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}



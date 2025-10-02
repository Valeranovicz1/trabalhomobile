import 'package:flutter/material.dart';

/// Documentação das Cores do Sistema - Paleta Netflix
/// 
/// Esta classe contém todas as cores utilizadas no aplicativo,
/// baseadas na paleta oficial da Netflix para manter consistência visual.
/// 
/// Cores Principais:
/// - Netflix Red: #E50914 (Cor principal da marca)
/// - Dark Background: #141414 (Fundo escuro principal)
/// - Light Background: #181818 (Fundo escuro secundário)
/// 
/// Cores Neutras:
/// - White: #FFFFFF (Texto principal em fundos escuros)
/// - Light Gray: #B3B3B3 (Texto secundário)
/// - Medium Gray: #808080 (Texto desabilitado)
/// - Dark Gray: #333333 (Elementos de interface)
/// 
/// Cores de Estado:
/// - Success: #46D369 (Confirmações e sucessos)
/// - Warning: #F5C842 (Avisos e atenções)
/// - Error: #F40612 (Erros e validações)
/// 
class AppColors {
  // Previne instanciação da classe
  AppColors._();

  /// Cores Principais da Netflix
  static const Color netflixRed = Color(0xFFE50914);
  static const Color darkBackground = Color(0xFF141414);
  static const Color lightBackground = Color(0xFF181818);
  
  /// Cores Neutras
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFB3B3B3);
  static const Color mediumGray = Color(0xFF808080);
  static const Color darkGray = Color(0xFF333333);
  static const Color black = Color(0xFF000000);
  
  /// Cores de Estado
  static const Color success = Color(0xFF46D369);
  static const Color warning = Color(0xFFF5C842);
  static const Color error = Color(0xFFF40612);
  
  /// Cores para Input Fields
  static const Color inputBackground = Color(0xFF333333);
  static const Color inputBorder = Color(0xFF737373);
  static const Color inputBorderFocused = Color(0xFFE50914);
  static const Color inputText = Color(0xFFFFFFFF);
  static const Color inputHint = Color(0xFF8C8C8C);
  
  /// Cores para Botões
  static const Color primaryButton = Color(0xFFE50914);
  static const Color primaryButtonHover = Color(0xFFF40612);
  static const Color secondaryButton = Color(0xFF333333);
  static const Color disabledButton = Color(0xFF404040);
  
  /// Gradientes
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF000000),
      Color(0xFF141414),
    ],
  );
  
  static const LinearGradient redGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFE50914),
      Color(0xFFF40612),
    ],
  );
}

/// Extensão para facilitar o uso das cores em widgets
extension AppColorsExtension on BuildContext {
  /// Retorna as cores do app
  AppColorsTheme get colors => AppColorsTheme();
}

/// Classe auxiliar para organizar as cores por categoria
class AppColorsTheme {
  // Cores principais
  Color get primary => AppColors.netflixRed;
  Color get background => AppColors.darkBackground;
  Color get surface => AppColors.lightBackground;
  
  // Cores de texto
  Color get textPrimary => AppColors.white;
  Color get textSecondary => AppColors.lightGray;
  Color get textDisabled => AppColors.mediumGray;
  
  // Cores de estado
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get error => AppColors.error;
}
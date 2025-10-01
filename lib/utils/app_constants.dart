import 'package:flutter/material.dart';

/// Classe para gerenciar constantes de texto utilizadas na aplicação
/// 
/// Esta classe centraliza todos os textos do app para facilitar:
/// - Manutenção e atualizações
/// - Futura implementação de localização (i18n)
/// - Consistência na nomenclatura
/// 
class AppTexts {
  AppTexts._(); // Previne instanciação

  // Textos gerais do app
  static const String appName = 'MovieDex';
  static const String appSubtitle = 'Seu catálogo pessoal de filmes';

  // Textos da tela de login
  static const String loginTitle = 'Bem-vindo de volta!';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Senha';
  static const String loginButton = 'Entrar';
  static const String rememberMe = 'Lembrar de mim';
  static const String forgotPassword = 'Esqueci minha senha';
  static const String continueWithGoogle = 'Continuar com Google';
  static const String newToMovieDx = 'Novo no MovieDex? ';
  static const String signUpNow = 'Cadastre-se agora';
  static const String or = 'ou';

  // Mensagens de validação
  static const String emailRequired = 'Por favor, insira seu email';
  static const String emailInvalid = 'Por favor, insira um email válido';
  static const String passwordRequired = 'Por favor, insira sua senha';
  static const String passwordMinLength = 'A senha deve ter pelo menos 6 caracteres';

  // Mensagens de feedback
  static const String loginSuccess = 'Login realizado com sucesso!';
  static const String loginError = 'Erro ao fazer login. Tente novamente.';
  static const String featureInDevelopment = 'Funcionalidade em desenvolvimento';
  static const String googleLoginInDevelopment = 'Login com Google em desenvolvimento';
  static const String signUpInDevelopment = 'Tela de cadastro em desenvolvimento';

  // Mensagens de acessibilidade
  static const String logoAccessibility = 'Logo do MovieDex';
  static const String emailFieldAccessibility = 'Campo de email';
  static const String passwordFieldAccessibility = 'Campo de senha';
  static const String showPasswordAccessibility = 'Mostrar senha';
  static const String hidePasswordAccessibility = 'Ocultar senha';
  static const String loginButtonAccessibility = 'Botão de login';
  static const String rememberMeAccessibility = 'Checkbox lembrar de mim';
}

/// Classe para gerenciar constantes de dimensões e espaçamentos
/// 
/// Define um sistema de design consistente para:
/// - Espaçamentos (padding, margin)
/// - Tamanhos de componentes
/// - Border radius
/// - Dimensões de ícones
/// 
class AppDimensions {
  AppDimensions._(); // Previne instanciação

  // Espaçamentos
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Dimensões de componentes
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double logoSize = 80.0;
  static const double iconSize = 24.0;
  static const double checkboxSize = 24.0;

  // Border radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusCircle = 999.0;

  // Constraints
  static const double maxFormWidth = 400.0;
  static const double minButtonWidth = 120.0;

  // Elevações
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
}

/// Classe para definir durações de animações
/// 
/// Centraliza todas as durações para manter consistência nas animações
/// e facilitar ajustes globais de performance
/// 
class AppDurations {
  AppDurations._(); // Previne instanciação

  // Animações rápidas
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);

  // Animações de entrada
  static const Duration fadeIn = Duration(milliseconds: 1500);
  static const Duration slideIn = Duration(milliseconds: 1200);

  // Simulações
  static const Duration loginSimulation = Duration(seconds: 2);
  static const Duration loadingMinimum = Duration(milliseconds: 800);

  // Debounce
  static const Duration debounceInput = Duration(milliseconds: 300);
  static const Duration debounceButton = Duration(milliseconds: 500);
}

/// Classe para definir estilos de texto padronizados
/// 
/// Centraliza definições de tipografia para manter consistência
/// visual em todo o aplicativo
/// 
class AppTextStyles {
  AppTextStyles._(); // Previne instanciação

  // Títulos
  static const TextStyle titleLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    height: 1.2,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
  );

  // Corpo do texto
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // Botões
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
  );
}
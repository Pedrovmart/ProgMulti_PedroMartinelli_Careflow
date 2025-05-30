import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';


class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: AppColors.primary,
      primaryColorDark: AppColors.primaryDark,
      primaryColorLight: AppColors.primaryLight,
      // accentColor: AppColors.accent, // accentColor está depreciado, use colorScheme.secondary
      // errorColor: AppColors.error, // errorColor está depreciado, use colorScheme.error

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDark,
        brightness: Brightness.light,
        surface: Colors.white,    // Definindo a superfície como branca
        // Outras cores podem ser ajustadas conforme necessário
        // primary: AppColors.primary, // O seedColor já define isso
        // onPrimary: Colors.white,
        // secondary: AppColors.accent,
        // onSecondary: Colors.white,
        // error: AppColors.error, // Se você tiver AppColors.error definido
        // onError: Colors.white,
        // onBackground: AppColors.primaryDark,
        // onSurface: AppColors.primaryDark,
      ),

      scaffoldBackgroundColor: Colors.white, // Mudando para fundo branco conforme solicitado

      fontFamily: 'Manrope', // Definindo a fonte primária como padrão (se configurada)

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        // displayMedium: AppTextStyles.displayMedium, // Adicionar se definido em AppTextStyles
        // displaySmall: AppTextStyles.displaySmall, // Adicionar se definido em AppTextStyles
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        // headlineSmall: AppTextStyles.headlineSmall, // Adicionar se definido em AppTextStyles
        titleLarge: AppTextStyles.titleMedium, // Material titleLarge mapeado para nosso titleMedium
        titleMedium: AppTextStyles.titleMedium,
        // titleSmall: AppTextStyles.titleSmall, // Adicionar se definido em AppTextStyles
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        // bodySmall: AppTextStyles.caption, // Material bodySmall mapeado para nosso caption
        labelLarge: AppTextStyles.labelLarge, // Para botões
        // labelMedium: AppTextStyles.labelMedium, // Adicionar se definido
        // labelSmall: AppTextStyles.labelSmall, // Adicionar se definido
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white, // Cor do título e ícones na AppBar
        elevation: 0, // Remove a sombra padrão da AppBar
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Cor de fundo do botão
          foregroundColor: Colors.white, // Cor do texto e ícone do botão
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: AppColors.accentLight.withValues(alpha: 0.7), // Cor de fundo clara para Cards com maior opacidade
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      ),


      // Defina outros temas de componentes aqui ( InputDecorationTheme, etc.)

    );
  }
}

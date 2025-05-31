import 'package:flutter/material.dart';
import 'app_colors.dart'; // Importar as cores definidas

// Definições de TextStyle baseadas no design da ProfissionalAgendamentosPage
// As fontes 'Manrope' e 'Noto Sans' devem ser adicionadas ao pubspec.yaml e à pasta assets/
// Por enquanto, usaremos as fontes padrão do sistema ou uma fallback comum.
const String _fontFamilyPrimary = 'Manrope'; // Exemplo, se configurado
const String _fontFamilySecondary = 'Noto Sans'; // Exemplo, se configurado

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    // Exemplo: Título grande, como o valor nos cards de estatística
    fontFamily: _fontFamilyPrimary,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineLarge = TextStyle(
    // Exemplo: 'Olá, Dr. Silva'
    fontFamily: _fontFamilyPrimary,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static const TextStyle headlineMedium = TextStyle(
    // Exemplo: Títulos de seção como 'Próximos compromissos'
    fontFamily: _fontFamilyPrimary,
    fontSize: 18.0,
    fontWeight: FontWeight.w600, // semibold
    color: AppColors.primaryDark,
  );

  static const TextStyle titleMedium = TextStyle(
    // Exemplo: Nome do paciente no item de agendamento 'Consulta com Maria Souza'
    fontFamily: _fontFamilyPrimary,
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // medium
    color: AppColors.primaryDark,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryDark,
  );

  static const TextStyle bodyMedium = TextStyle(
    // Exemplo: Título do card de estatística 'Pacientes hoje', Hora do agendamento '10:00 - 10:30'
    fontFamily: _fontFamilySecondary,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primary,
  );
  
  static const TextStyle bodyMediumBold = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // medium (usado no HTML como font-medium para o título do card)
    color: AppColors.primary, 
  );

  static const TextStyle labelLarge = TextStyle(
    // Exemplo: Texto dos botões de ação rápida 'Buscar paciente'
    fontFamily: _fontFamilyPrimary,
    fontSize: 14.0,
    fontWeight: FontWeight.w600, // semibold
    color: Colors.white, // Para contraste em botões com fundo primário
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamilySecondary,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryLight,
  );

  // Adicione mais estilos conforme necessário
}

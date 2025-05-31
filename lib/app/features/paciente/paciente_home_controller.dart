import 'package:flutter/material.dart';

class PacienteHomeController {
  void navigateToConsultas(BuildContext context) {
    // Implementar a lógica de navegação para a página de consultas
    Navigator.pushNamed(context, '/consultas');
  }

  void navigateToHistoricoMedico(BuildContext context) {
    // Implementar a lógica de navegação para a página de histórico médico
    Navigator.pushNamed(context, '/historico_medico');
  }

  void navigateToPerfil(BuildContext context) {
    // Implementar a lógica de navegação para a página de perfil
    Navigator.pushNamed(context, '/perfil');
  }
}
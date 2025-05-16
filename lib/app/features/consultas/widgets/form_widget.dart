import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/features/consultas/calendario_controller.dart';

class FormWidget extends StatelessWidget {
  final CalendarioController controller;
  
  const FormWidget({Key? key, required this.controller}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Agendar Nova Consulta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            TextField(
              controller: controller.descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: 'Digite a descrição da consulta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.light.withOpacity(0.2),
                labelStyle: TextStyle(color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                final currentContext = context;
                showTimePicker(
                  context: currentContext,
                  initialTime: controller.selectedTime ?? TimeOfDay.now(),
                ).then((time) {
                  if (time != null && currentContext.mounted) {
                    controller.selectedTime = time;
                    controller.horaController.text = time.format(currentContext);
                  }
                });
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: controller.horaController,
                  decoration: InputDecoration(
                    labelText: 'Hora',
                    hintText: 'Selecione a hora',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: AppColors.light.withOpacity(0.2),
                    labelStyle: TextStyle(color: AppColors.primaryDark),
                    suffixIcon: Icon(Icons.access_time, color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: controller.selectedProfissionalId,
              items: controller.profissionais.map((profissional) {
                return DropdownMenuItem<String>(
                  value: profissional.id,
                  child: Text(profissional.nome),
                );
              }).toList(),
              onChanged: (value) {
                controller.selectedProfissionalId = value;
              },
              decoration: InputDecoration(
                labelText: 'Selecione o Profissional',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.light.withOpacity(0.2),
                labelStyle: TextStyle(color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await controller.agendarConsulta(context);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Consulta agendada com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }

                    // Reset form
                    controller.descricaoController.clear();
                    controller.horaController.clear();
                    controller.selectedProfissionalId = null;
                    controller.selectedTime = null;

                    // Refresh events
                    await controller.fetchConsultations();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao agendar consulta: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('AGENDAR CONSULTA'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

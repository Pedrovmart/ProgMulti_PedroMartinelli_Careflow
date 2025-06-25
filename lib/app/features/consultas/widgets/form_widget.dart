import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/features/consultas/base_agendamentos_controller.dart';

class FormWidget extends StatefulWidget {
  final BaseAgendamentosController controller;

  const FormWidget({
    super.key,
    required this.controller,
  });

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller.profissionais.isEmpty) {
      _carregarProfissionais();
    }
  }
  Future<void> _carregarProfissionais() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.controller.fetchProfissionais();
    } catch (e) {
      debugPrint('Erro ao carregar profissionais: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardTheme.color ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
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
              controller: widget.controller.queixaPacienteController,
              decoration: InputDecoration(
                labelText: 'Queixa do Paciente',
                hintText: 'Digite sua queixa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.accent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryLight),
                ),
                filled: true,
                fillColor: AppColors.light.withValues(alpha: 0.1),
                labelStyle: TextStyle(color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.controller.dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Data Selecionada',
                hintText: 'Selecione uma data no calendário',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.accent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryLight),
                ),
                filled: true,
                fillColor: AppColors.light.withValues(alpha: 0.1),
                labelStyle: TextStyle(color: AppColors.primaryDark),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                final currentContext = context;
                showTimePicker(
                  context: currentContext,
                  barrierColor: AppColors.primaryDark.withValues(alpha: 0.5),
                  initialEntryMode: TimePickerEntryMode.input,
                  initialTime:
                      widget.controller.selectedTime ?? TimeOfDay.now(),
                ).then((time) {
                  if (time != null && currentContext.mounted) {
                    widget.controller.selectedTime = time;
                    widget.controller.timeController.text = time.format(
                      currentContext,
                    );
                  }
                });
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: widget.controller.timeController,
                  decoration: InputDecoration(
                    labelText: 'Hora',
                    hintText: 'Selecione a hora',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.accent,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryLight,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.light.withValues(alpha: 0.1),
                    labelStyle: TextStyle(color: AppColors.primaryDark),
                    suffixIcon: Icon(
                      Icons.access_time,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryLight),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                )
                : DropdownButtonFormField<String>(
                  value: widget.controller.profissionais.isEmpty ? null : 
                         (widget.controller.selectedProfissionalId != null && 
                          widget.controller.profissionais.any((p) => p.id == widget.controller.selectedProfissionalId) ? 
                          widget.controller.selectedProfissionalId : null),
                  hint: const Text(
                    'Selecione o profissional',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Profissional',
                    hintText: 'Selecione o profissional',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.accent,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryLight,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.light.withValues(alpha: 0.1),
                    labelStyle: TextStyle(color: AppColors.primaryDark),
                    suffixIcon:
                        widget.controller.profissionais.isEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.refresh,
                                color: AppColors.primary,
                              ),
                              onPressed: _carregarProfissionais,
                              tooltip: 'Recarregar lista',
                            )
                            : null,
                  ),
                  items:
                      widget.controller.profissionais.isEmpty
                          ? [
                            DropdownMenuItem<String>(
                              value: '',
                              enabled: false,
                              child: Text(
                                'Nenhum profissional encontrado',
                                style: TextStyle(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ),
                          ]
                          : widget.controller.profissionais
                              .map<DropdownMenuItem<String>>((profissional) {
                                return DropdownMenuItem<String>(
                                  value: profissional.id,
                                  child: Text(
                                    '${profissional.nome}${profissional.especialidade.isNotEmpty ? ' - ${profissional.especialidade}' : ''}',
                                  ),
                                );
                              }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.controller.selectedProfissionalId = newValue;
                    });
                  },
                ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await widget.controller.agendarConsulta(context);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Consulta agendada com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }

                    widget.controller.queixaPacienteController.clear();
                    widget.controller.timeController.clear();
                    widget.controller.selectedProfissionalId = null;
                    widget.controller.selectedTime = null;

                    await widget.controller.fetchConsultations();
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

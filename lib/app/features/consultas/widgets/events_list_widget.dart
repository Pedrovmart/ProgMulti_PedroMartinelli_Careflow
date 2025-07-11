import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:careflow_app/app/features/consultas/base_agendamentos_controller.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class EventsListWidget extends StatefulWidget {
  final BaseAgendamentosController controller;
  
  const EventsListWidget({super.key, required this.controller});

  @override
  State<EventsListWidget> createState() => _EventsListWidgetState();
}

class _EventsListWidgetState extends State<EventsListWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateList);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateList);
    super.dispose();
  }
  void _updateList() {
    if (mounted) {
      setState(() {
        log('EventsListWidget atualizado via listener');
        final events = widget.controller.getEventsForDay(widget.controller.selectedDay);
        log('Eventos na lista atualizada: ${events.length}');
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final events = widget.controller.getEventsForDay(widget.controller.selectedDay);
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Consultas do Dia',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const Divider(),
            events.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text('Nenhuma consulta agendada para este dia', style: TextStyle(color: AppColors.primary.withValues(alpha: 0.7))),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        elevation: 0,
                        color: AppColors.light.withValues(alpha: 0.5),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.accentLight,
                            child: const Icon(Icons.calendar_today, color: AppColors.accentDark),
                          ),
                          title: Text(
                            'Médico: ${event.nome}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          subtitle: Text('Horário: ${event.hora}', style: Theme.of(context).textTheme.bodyMedium),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Data: ${event.data}'),
                                  if (event.queixaPaciente.isNotEmpty)
                                    Text('Queixa: ${event.queixaPaciente}'),
                                  if (event.diagnostico.isNotEmpty)
                                    Text('Diagnóstico: ${event.diagnostico}'),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        icon: const Icon(Icons.edit, color: AppColors.primary),
                                        label: const Text('Editar', style: TextStyle(color: AppColors.primary)),
                                        onPressed: () {
                                          _showEditDialog(context, event);
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton.icon(
                                        icon: const Icon(Icons.cancel, color: AppColors.accentDark),
                                        label: const Text('Cancelar', style: TextStyle(color: AppColors.accentDark)),
                                        onPressed: () {
                                          _showCancelDialog(context, event);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }


  void _showEditDialog(BuildContext context, ConsultaModel consulta) {
    final queixaController = TextEditingController(text: consulta.queixaPaciente);
    final timeController = TextEditingController(text: consulta.hora);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Consulta', style: TextStyle(color: AppColors.primaryDark)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: queixaController,
                decoration: const InputDecoration(
                  labelText: 'Queixa do Paciente',
                  labelStyle: TextStyle(color: AppColors.primary),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryLight)),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final initialTimeText = timeController.text;
                  TimeOfDay initialTime = TimeOfDay.now();
                  if (initialTimeText.isNotEmpty) {
                    try {
                      final parts = initialTimeText.split(':');
                      initialTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                    } catch (e) {
                      log('Erro ao parsear hora: $e');
                    }
                  }

                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: initialTime,
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    }
                  );
                  if (picked != null) {
                    if (context.mounted) {
                      final formattedTime = MaterialLocalizations.of(context).formatTimeOfDay(picked, alwaysUse24HourFormat: true);
                      timeController.text = formattedTime;
                    }
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Horário',
                    labelStyle: TextStyle(color: AppColors.primary),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryLight)),
                  ),
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: timeController,
                    builder: (context, value, child) {
                      return Text(
                        value.text.isEmpty ? 'Selecionar horário' : value.text,
                        style: TextStyle(color: value.text.isEmpty ? Colors.grey : AppColors.primaryDark, fontSize: 16),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.primary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.light),
            onPressed: () async {
              if (consulta.id == null) {
                log('Erro: ID da consulta é nulo ao tentar atualizar parcialmente.');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao salvar: ID da consulta não encontrado.')),
                );
                return;
              }
              
              try {
                final consultaAtualizada = ConsultaModel(
                  id: consulta.id,
                  data: consulta.data,
                  hora: timeController.text,
                  queixaPaciente: queixaController.text,
                  idPaciente: consulta.idPaciente,
                  idMedico: consulta.idMedico,
                  nome: consulta.nome,
                  descricao: consulta.descricao,
                  diagnostico: consulta.diagnostico,
                );
                
                await widget.controller.atualizarConsulta(consultaAtualizada);
                
                if (context.mounted) {
                  Navigator.pop(context); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Consulta atualizada com sucesso!'),
                      backgroundColor: AppColors.success, 
                    ),
                  );
                }
              } catch (e) {
                log('Erro ao atualizar consulta no _showEditDialog: $e');
                if (context.mounted) {
                  Navigator.pop(context); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao atualizar consulta: ${e.toString().replaceFirst("Exception: ", "")}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
  
  void _showCancelDialog(BuildContext context, ConsultaModel consulta) {

    // Armazenar o BuildContext global para uso após o diálogo ser fechado
    final globalContext = context;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(

        title: const Text('Cancelar Consulta'),
        content: Text('Deseja realmente cancelar a consulta de ${consulta.data} às ${consulta.hora}?'),
        actions: [
          TextButton(

            onPressed: () => Navigator.pop(dialogContext),

            child: const Text('Não'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

            onPressed: () async {
              // Fechar o diálogo de confirmação
              Navigator.pop(dialogContext);
              
              if (consulta.id != null) {
                log('Iniciando cancelamento da consulta ID: ${consulta.id}');
                // Chamar o método de cancelamento e aguardar o resultado
                final success = await widget.controller.cancelarConsulta(consulta.id!);
                log('Resultado do cancelamento: $success');
                
                // Mostrar feedback sempre que a operação terminar
                if (mounted) {
                  log('Widget ainda está montado, exibindo feedback');
                  ScaffoldMessenger.of(globalContext).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Consulta cancelada com sucesso!' : 'Não foi possível cancelar a consulta'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                } else {
                  log('Widget não está mais montado, não é possível exibir feedback');
                }
              }

            },
            child: const Text('Sim, Cancelar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

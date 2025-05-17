import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/features/consultas/calendario_controller.dart';
import 'package:careflow_app/app/models/consulta_model.dart';

class EventsListWidget extends StatefulWidget {
  final CalendarioController controller;
  
  const EventsListWidget({super.key, required this.controller});

  @override
  State<EventsListWidget> createState() => _EventsListWidgetState();
}

class _EventsListWidgetState extends State<EventsListWidget> {
  @override
  void initState() {
    super.initState();
    // Adiciona listener para atualizar a lista quando o dia selecionado mudar
    widget.controller.addListener(_updateList);
  }

  @override
  void dispose() {
    // Remove o listener quando o widget for descartado
    widget.controller.removeListener(_updateList);
    super.dispose();
  }

  // Força a atualização da lista quando o controller notificar mudanças
  void _updateList() {
    if (mounted) {
      setState(() {
        print('EventsListWidget atualizado via listener');
        final events = widget.controller.getEventsForDay(widget.controller.selectedDay);
        print('Eventos na lista atualizada: ${events.length}');
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final events = widget.controller.getEventsForDay(widget.controller.selectedDay);
    
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Consultas do Dia',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const Divider(),
            events.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text('Nenhuma consulta agendada para este dia'),
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
                        color: AppColors.light.withOpacity(0.1),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.accent,
                            child: const Icon(Icons.calendar_today, color: Colors.white),
                          ),
                          title: Text(
                            event.descricao,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Horário: ${event.hora}'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Médico: ${event.nomeMedico}'),
                                  Text('Data: ${CalendarioController.formatDate(event.data)}'),
                                  Text('Paciente: ${event.idPaciente}'),
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
                                        label: const Text('Editar'),
                                        onPressed: () {
                                          // Implementar edição de consulta
                                          _showEditDialog(context, event);
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton.icon(
                                        icon: const Icon(Icons.cancel, color: Colors.red),
                                        label: const Text('Cancelar'),
                                        onPressed: () {
                                          // Implementar cancelamento de consulta
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


  // Mostra diálogo de edição de consulta
  void _showEditDialog(BuildContext context, ConsultaModel consulta) {
    // Controladores para os campos de texto
    final descricaoController = TextEditingController(text: consulta.descricao);
    final horaController = TextEditingController(text: consulta.hora);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Consulta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: horaController,
                decoration: const InputDecoration(
                  labelText: 'Horário',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Criar uma nova consulta com os dados atualizados
              final consultaAtualizada = ConsultaModel(
                id: consulta.id,
                data: consulta.data,
                hora: horaController.text,
                descricao: descricaoController.text,
                queixaPaciente: consulta.queixaPaciente,
                idPaciente: consulta.idPaciente,
                idMedico: consulta.idMedico,
                diagnostico: consulta.diagnostico,
              );
              
              // Atualizar a consulta no controller
              widget.controller.atualizarConsulta(consultaAtualizada);
              
              // Fechar o diálogo
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
  
  // Mostra diálogo de confirmação de cancelamento de consulta
  void _showCancelDialog(BuildContext context, ConsultaModel consulta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Consulta'),
        content: Text('Deseja realmente cancelar a consulta de ${CalendarioController.formatDate(consulta.data)} às ${consulta.hora}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // Cancelar a consulta no controller
              if (consulta.id != null) {
                widget.controller.cancelarConsulta(consulta.id!);
              }
              
              // Fechar o diálogo
              Navigator.pop(context);
            },
            child: const Text('Sim, Cancelar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

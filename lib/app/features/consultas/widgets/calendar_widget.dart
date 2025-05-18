import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/features/consultas/calendario_controller.dart';
import 'package:careflow_app/app/models/consulta_model.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarioController controller;
  
  const CalendarWidget({super.key, required this.controller});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar<ConsultaModel>(
          firstDay: controller.firstDay,
          lastDay: controller.lastDay,
          focusedDay: controller.getValidFocusedDay(),
          currentDay: DateTime.now(),
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) => isSameDay(day, controller.selectedDay),
          onDaySelected: (selectedDay, focusedDay) {
            controller.onDaySelected(selectedDay);
            
            (context as Element).markNeedsBuild();
          },
          eventLoader: (day) => controller.getEventsForDay(day),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return const SizedBox();
              
              return Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                  ),
                  width: 8,
                  height: 8,
                ),
              );
            },
            // Personaliza a célula do dia para destacar dias com eventos
            defaultBuilder: (context, day, focusedDay) {
              final events = controller.getEventsForDay(day);
              final isToday = isSameDay(day, DateTime.now());
              final isSelected = isSameDay(day, controller.selectedDay);
              
              // Não personaliza dias já destacados (hoje/selecionado)
              if (isToday || isSelected) {
                return null; // Usa o estilo padrão para hoje/selecionado
              }
              
              // Destaca dias com eventos
              if (events.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.success, width: 1.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              }
              return null; // Usa o estilo padrão para dias sem eventos
            },
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(color: AppColors.primary),
            defaultTextStyle: TextStyle(color: AppColors.primaryDark),
            todayTextStyle: const TextStyle(color: Colors.white),
            selectedTextStyle: const TextStyle(color: Colors.white),
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            formatButtonDecoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            formatButtonTextStyle: const TextStyle(color: Colors.white),
            leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.primary),
            rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.primary),
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
      ),
    );
  }
}

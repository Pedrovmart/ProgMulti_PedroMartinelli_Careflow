import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
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
            color: Colors.grey.withOpacity(0.2),
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
            // Atualiza o dia selecionado no controller
            controller.selectedDay = selectedDay;
            controller.dataController.text = DateFormat('dd/MM/yyyy').format(selectedDay);
            // Força a atualização da UI
            (context as Element).markNeedsBuild();
            
            // Log para depuração
            log('Dia selecionado: ${selectedDay.toString()}');
            final events = controller.getEventsForDay(selectedDay);
            log('Número de eventos no dia selecionado: ${events.length}');
            
            // Atualiza o controller em um microtask para evitar problemas de build
            Future.microtask(() {
              // Isso força o controller a atualizar seus listeners sem chamar notifyListeners diretamente
              controller.onDaySelected(selectedDay);
            });
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

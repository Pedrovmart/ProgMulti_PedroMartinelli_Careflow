import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/features/consultas/pacientes_agendamentos_controller.dart';
import 'package:careflow_app/app/models/consulta_model.dart';

class CalendarWidget extends StatefulWidget {
  final PacientesAgendamentosController controller;
  
  const CalendarWidget({
    super.key, 
    required this.controller,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.controller.getValidFocusedDay();
    widget.controller.addListener(_onControllerUpdated);
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerUpdated);
      widget.controller.addListener(_onControllerUpdated);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdated);
    super.dispose();
  }

  void _onControllerUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final localSelectedDay = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );
    
    setState(() {
      _focusedDay = focusedDay;
    });
    
    widget.controller.onDaySelected(localSelectedDay);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return Container(
      decoration: _buildBoxDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar<ConsultaModel>(
          firstDay: widget.controller.firstDay,
          lastDay: widget.controller.lastDay,
          focusedDay: _focusedDay,
          currentDay: today,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) => isSameDay(day, widget.controller.selectedDay),
          onDaySelected: _onDaySelected,
          eventLoader: widget.controller.getEventsForDay,
          calendarBuilders: _buildCalendarBuilders(context),
          calendarStyle: _buildCalendarStyle(),
          headerStyle: _buildHeaderStyle(context),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardTheme.color ?? 
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
    );
  }

  CalendarStyle _buildCalendarStyle() {
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: AppColors.accentLight,
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      weekendTextStyle: const TextStyle(color: AppColors.primary),
      defaultTextStyle: const TextStyle(color: AppColors.primaryDark),
      todayTextStyle: const TextStyle(color: AppColors.primaryDark),
      selectedTextStyle: const TextStyle(color: AppColors.light),
    );
  }

  HeaderStyle _buildHeaderStyle(BuildContext context) {
    return HeaderStyle(
      titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: AppColors.primaryDark,
      ),
      formatButtonDecoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      formatButtonTextStyle: const TextStyle(color: AppColors.light),
      leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.primary),
      rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.primary),
      formatButtonVisible: false,
      titleCentered: true,
    );
  }

  CalendarBuilders<ConsultaModel> _buildCalendarBuilders(BuildContext context) {
    return CalendarBuilders<ConsultaModel>(
      markerBuilder: (context, date, events) {
        if (events.isEmpty) return const SizedBox();
        
        return Positioned(
          right: 1,
          bottom: 1,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
            ),
            width: 8,
            height: 8,
          ),
        );
      },
      defaultBuilder: (context, day, focusedDay) {
        final events = widget.controller.getEventsForDay(day);
        final isToday = isSameDay(day, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
        final isSelected = isSameDay(day, widget.controller.selectedDay);
        
        if (isToday || isSelected) {
          return null;
        }
        
        if (events.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.accent, width: 1.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          );
        }
        return null;
      },
    );
  }
}

class CalendarControllerProvider extends InheritedWidget {
  final PacientesAgendamentosController controller;

  const CalendarControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static CalendarControllerProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CalendarControllerProvider>();
  }

  @override
  bool updateShouldNotify(CalendarControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}

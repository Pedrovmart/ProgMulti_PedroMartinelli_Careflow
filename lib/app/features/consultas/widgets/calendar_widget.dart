import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:careflow_app/app/core/ui/app_text_styles.dart';
import 'package:careflow_app/app/features/consultas/base_agendamentos_controller.dart';
import 'package:careflow_app/app/models/consulta_model.dart';

class CalendarWidget extends StatefulWidget {
  final BaseAgendamentosController controller;
  
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
          color: AppColors.primaryDark.withOpacity(0.06),
          spreadRadius: 0.5,
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  CalendarStyle _buildCalendarStyle() {
    final theme = Theme.of(context);
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15), 
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.4),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          )
        ]
      ),
      markerDecoration: BoxDecoration(
        color: AppColors.primaryDark,
        shape: BoxShape.circle,
      ),
      defaultTextStyle: AppTextStyles.caption.copyWith(color: theme.colorScheme.onSurface, fontSize: 13.0),
      weekendTextStyle: AppTextStyles.caption.copyWith(color: theme.colorScheme.onSurface, fontSize: 13.0),
      outsideTextStyle: AppTextStyles.caption.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
      todayTextStyle: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 13.0),
      selectedTextStyle: AppTextStyles.caption.copyWith(color: AppColors.light, fontWeight: FontWeight.bold, fontSize: 13.0),
    );
  }

  HeaderStyle _buildHeaderStyle(BuildContext context) {
    return HeaderStyle(
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.primaryDark,
        fontWeight: FontWeight.bold,
      ),
      leftChevronIcon: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: AppColors.light.withValues(alpha: 0.7),
          shape: BoxShape.circle,
           boxShadow: [ BoxShadow( color: AppColors.primaryDark.withValues(alpha: 0.1), blurRadius: 2, offset: Offset(0,1))]
        ),
        child: Icon(Icons.chevron_left_rounded, color: AppColors.primaryDark, size: 20),
      ),
      rightChevronIcon: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: AppColors.light.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          boxShadow: [ BoxShadow( color: AppColors.primaryDark.withValues(alpha: 0.1), blurRadius: 2, offset: Offset(0,1))]
        ),
        child: Icon(Icons.chevron_right_rounded, color: AppColors.primaryDark, size: 20),
      ),
      leftChevronPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      rightChevronPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      headerPadding: const EdgeInsets.symmetric(vertical: 16.0),
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: 0.9),
            ),
            width: 7,
            height: 7,
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
            child: Center(
              child: Text(
                '${day.day}',
                style: AppTextStyles.caption.copyWith(color: Theme.of(context).colorScheme.onSurface, fontSize: 13.0),
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
  final BaseAgendamentosController controller;

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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:careflow_app/app/models/consulta_model.dart';
import 'package:careflow_app/app/core/providers/consultas_provider.dart';
import 'package:careflow_app/app/core/providers/profissional_provider.dart';
import 'package:careflow_app/app/core/providers/auth_provider.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';
import 'package:intl/intl.dart';

//TODO: REMOVER METODOS DA PAGE E PASSAR PARA O PROVIDER E FAZER CRIAÇÃO DE WIDGETS!!!!
class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  String? _selectedProfissionalId;
  DateTime _selectedDay = DateTime.now();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _dataController.text = DateFormat('dd/MM/yyyy').format(_selectedDay);
    Provider.of<ProfissionalProvider>(
      context,
      listen: false,
    ).fetchProfissionais();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _dataController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                onSurface: AppColors.primaryDark,
              ),
            ),
            child: child!,
          ),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _horaController.text = _selectedTime!.format(context);
      });
    }
  }

  void _agendarConsulta(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final consultasProvider = Provider.of<ConsultasProvider>(
      context,
      listen: false,
    );
    final pacienteId = authProvider.currentUser?.uid;

    if (_selectedTime == null ||
        _descricaoController.text.isEmpty ||
        _selectedProfissionalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    if (pacienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Usuário não autenticado!')),
      );
      return;
    }

    final novaConsulta = ConsultaModel(
      id: '',
      data: _selectedDay,
      hora: _horaController.text,
      queixaPaciente: 'Queixa não especificada',
      idPaciente: pacienteId,
      idMedico: _selectedProfissionalId!,
      descricao: _descricaoController.text,
      diagnostico: 'Diagnóstico pendente',
    );

    try {
      await consultasProvider.agendarConsulta(novaConsulta);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consulta agendada com sucesso!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao agendar consulta: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profissionalProvider = Provider.of<ProfissionalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Consulta'),
        backgroundColor: AppColors.primaryDark,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 20),
            _buildTextField(
              _dataController,
              'Data da Consulta',
              readOnly: true,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: AbsorbPointer(
                child: _buildTextField(
                  _horaController,
                  'Hora da Consulta',
                  hintText: 'Selecione a hora',
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildDropdown(profissionalProvider),
            const SizedBox(height: 10),
            _buildTextField(_descricaoController, 'Descrição da Consulta'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _agendarConsulta(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Text(
                  'Agendar Consulta',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _selectedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _dataController.text = DateFormat(
                'dd/MM/yyyy',
              ).format(selectedDay);
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: const TextStyle(color: Colors.red),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            formatButtonDecoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            formatButtonTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            titleCentered: true,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool readOnly = false,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AppColors.light.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildDropdown(ProfissionalProvider profissionalProvider) {
    return DropdownButtonFormField<String>(
      value: _selectedProfissionalId,
      items:
          profissionalProvider.profissionais.map((profissional) {
            return DropdownMenuItem(
              value: profissional.id,
              child: Text(profissional.nome),
            );
          }).toList(),
      onChanged: (value) => setState(() => _selectedProfissionalId = value),
      decoration: InputDecoration(
        labelText: 'Selecione o Profissional',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AppColors.light.withValues(alpha: 0.2),
      ),
    );
  }
}

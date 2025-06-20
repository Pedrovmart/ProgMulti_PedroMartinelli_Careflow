import 'package:careflow_app/app/core/utils/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class EditProfileModal extends StatefulWidget {
  final Map<String, String> initialData;
  final List<String> editableFields;
  final List<String> readOnlyFields;
  final Function(Map<String, String>) onSave;

  const EditProfileModal({
    super.key,
    required this.initialData,
    required this.editableFields,
    this.readOnlyFields = const [],
    required this.onSave,
  });

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controllers = {};

    for (final field in widget.editableFields) {
      _controllers[field] = TextEditingController(
        text: widget.initialData[field] ?? '',
      );
    }

    for (final field in widget.readOnlyFields) {
      _controllers[field] = TextEditingController(
        text: widget.initialData[field] ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedData = <String, String>{};
      for (final entry in _controllers.entries) {
        updatedData[entry.key] = entry.value.text;
      }


      for (final entry in widget.initialData.entries) {
        if (!updatedData.containsKey(entry.key)) {
          updatedData[entry.key] = entry.value;
        }
      }

      await widget.onSave(updatedData);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar alterações: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Editar Perfil',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ...widget.readOnlyFields.map(
                  (field) => _buildTextField(
                    field,
                    _controllers[field]!,
                    readOnly: true,
                  ),
                ),

                ...widget.editableFields.map(
                  (field) => _buildTextField(field, _controllers[field]!),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _isSaving
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('Salvar Alterações'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String field,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    final isEmailField = field.toLowerCase() == 'email';
    final isReadOnly = readOnly || isEmailField;

    final inputFormatter = switch (field.toLowerCase()) {
      'cpf' => InputFormatters.cpfFormatter,
      'telefone' => InputFormatters.phoneFormatter,
      'datanascimento' => InputFormatters.dateFormatter,
      _ => null,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        inputFormatters: inputFormatter != null ? [inputFormatter] : null,
        decoration: InputDecoration(
          labelText: _getFieldLabel(field),
          border: const OutlineInputBorder(),
          filled: isReadOnly,
          fillColor: isReadOnly ? Colors.grey[200] : null,
          suffixIcon:
              isReadOnly
                  ? const Icon(Icons.lock_outline, color: Colors.grey)
                  : null,
        ),
        validator: _getValidator(field),
      ),
    );
  }
}

String _getFieldLabel(String field) {
  return switch (field.toLowerCase()) {
    'cpf' => 'CPF',
    'telefone' => 'Telefone',
    'datanascimento' => 'Data de Nascimento',
    _ => field
        .replaceFirst(field[0], field[0].toUpperCase())
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}'),
  };
}

String? Function(String?)? _getValidator(String field) {
  return (String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, preencha este campo';
    }

    switch (field.toLowerCase()) {
      case 'cpf':
        if (value.replaceAll(RegExp(r'[^0-9]'), '').length != 11) {
          return 'CPF inválido';
        }
        break;
      case 'telefone':
        if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
          return 'Telefone inválido';
        }
        break;
      case 'datanascimento':
        final parts = value.split('/');
        if (parts.length != 3) return 'Data inválida';

        try {
          final date = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
          if (date.isAfter(DateTime.now())) {
            return 'Data não pode ser futura';
          }
        } catch (e) {
          return 'Data inválida';
        }
        break;
    }
    return null;
  };
}

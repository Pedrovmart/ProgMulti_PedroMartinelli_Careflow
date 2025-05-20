import 'package:flutter/material.dart';
import 'package:careflow_app/app/core/ui/app_colors.dart';

class EditProfileModal extends StatefulWidget {
  final Map<String, String> initialData;
  final List<String> editableFields;
  final List<String> readOnlyFields;
  final Function(Map<String, String>) onSave;

  const EditProfileModal({
    Key? key,
    required this.initialData,
    required this.editableFields,
    this.readOnlyFields = const [],
    required this.onSave,
  }) : super(key: key);

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
    
    // Inicializar controllers para campos editáveis
    for (final field in widget.editableFields) {
      _controllers[field] = TextEditingController(
        text: widget.initialData[field] ?? '',
      );
    }
    
    // Inicializar controllers para campos somente leitura
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
      // Coletar dados atualizados
      final updatedData = <String, String>{};
      for (final entry in _controllers.entries) {
        updatedData[entry.key] = entry.value.text;
      }

      // Adicionar campos não editáveis de volta
      for (final entry in widget.initialData.entries) {
        if (!updatedData.containsKey(entry.key)) {
          updatedData[entry.key] = entry.value;
        }
      }

      // Chamar callback de salvamento
      await widget.onSave(updatedData);
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar alterações: ${e.toString()}')),
      );
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
                
                // Campos somente leitura
                ...widget.readOnlyFields.map((field) => _buildTextField(
                  field,
                  _controllers[field]!,
                  readOnly: true,
                )),
                
                // Campos editáveis
                ...widget.editableFields.map((field) => _buildTextField(
                  field,
                  _controllers[field]!,
                )),
                
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
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
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
    // Converter o nome do campo para um formato mais amigável para exibição
    final label = field.replaceFirst(field[0], field[0].toUpperCase())
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: readOnly,
          fillColor: readOnly ? Colors.grey[200] : null,
        ),
        validator: readOnly
            ? null
            : (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, preencha este campo';
                }
                return null;
              },
      ),
    );
  }
}

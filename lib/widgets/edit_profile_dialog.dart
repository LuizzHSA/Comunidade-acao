import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Diálogo de edição do perfil, usado pela tela de perfil.
class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const EditProfileDialog(),
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().user;
    _nameCtrl = TextEditingController(text: user.name);
    _cityCtrl = TextEditingController(text: user.city);
    _bioCtrl = TextEditingController(text: user.bio);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final state = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);
    state.updateProfile(
      name: _nameCtrl.text,
      city: _cityCtrl.text,
      bio: _bioCtrl.text,
    );
    Navigator.pop(context, true);
    messenger.showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = context.read<AppState>().user.email;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
      ),
      title: const Text('Editar Perfil'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                maxLength: 60,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return 'Informe um nome com pelo menos 2 letras.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _cityCtrl,
                textCapitalization: TextCapitalization.words,
                maxLength: 60,
                decoration: const InputDecoration(
                  labelText: 'Cidade / Estado',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _bioCtrl,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 120,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Sobre você (opcional)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                initialValue: email,
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'E-mail da conta',
                  prefixIcon: Icon(Icons.mail_outline),
                  helperText: 'O e-mail não pode ser alterado aqui.',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.onPrimary,
            minimumSize: const Size(96, 44),
          ),
          onPressed: _save,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

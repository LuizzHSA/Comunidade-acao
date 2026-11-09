import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class CreateCampaignDialog extends StatefulWidget {
  const CreateCampaignDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateCampaignDialog(),
    );
  }

  @override
  State<CreateCampaignDialog> createState() => _CreateCampaignDialogState();
}

class _CreateCampaignDialogState extends State<CreateCampaignDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _locationController = TextEditingController();
  final _targetController = TextEditingController();
  String _selectedCategory = 'Alimentos';

  final List<String> _categories = [
    'Alimentos',
    'Roupas & Agasalhos',
    'Dinheiro / Pix',
    'Voluntariado',
    'Brinquedos',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _locationController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AppState>().addNewCampaign(
            title: _titleController.text.trim(),
            subtitle: _subtitleController.text.trim(),
            category: _selectedCategory,
            location: _locationController.text.trim().isEmpty
                ? 'São Paulo, SP'
                : _locationController.text.trim(),
            targetLabel: _targetController.text.trim().isEmpty
                ? 'Meta: 100 itens'
                : _targetController.text.trim(),
          );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primaryContainer,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          ),
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Campanha cadastrada com sucesso!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                    ),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: AppTheme.primaryContainer,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Criar Nova Campanha',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'Cadastre sua iniciativa comunitária em poucos passos',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Título da Campanha',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ex: Sopão Solidário da Comunidade',
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Informe o título' : null,
              ),
              const SizedBox(height: 14),
              Text(
                'Descrição Resumida',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _subtitleController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Explique brevemente quem será beneficiado e a urgência',
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 14),
              Text(
                'Categoria da Causa',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Localização (Bairro / Cidade)',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Ex: Paraisópolis, São Paulo - SP',
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Meta Inicial (ex: 200 cestas ou R\$ 5.000)',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _targetController,
                decoration: InputDecoration(
                  hintText: 'Meta: 200 cestas',
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryContainer,
                  foregroundColor: AppTheme.onPrimary,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                  ),
                ),
                onPressed: _submit,
                icon: const Icon(Icons.rocket_launch, size: 20),
                label: const Text(
                  'Publicar Campanha',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


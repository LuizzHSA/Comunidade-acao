import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/fluent_theme.dart';
import '../widgets/custom_image.dart';

class WindowsCreateCampaignView extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const WindowsCreateCampaignView({
    super.key,
    required this.onCancel,
    required this.onSuccess,
  });

  @override
  State<WindowsCreateCampaignView> createState() =>
      _WindowsCreateCampaignViewState();
}

class _WindowsCreateCampaignViewState extends State<WindowsCreateCampaignView> {
  final _titleController = TextEditingController(
    text: 'Reforma da Quadra Esportiva Vila Nova',
  );
  final _descController = TextEditingController(
    text:
        'A comunidade da Vila Nova se reuniu para revitalizar a nossa única quadra poliesportiva. Atualmente o piso está danificado e sem redes nos aros de basquete. Toda ajuda com materiais de construção e mão de obra voluntária aos finais de semana fará uma enorme diferença na vida das nossas crianças.',
  );
  final _addressController = TextEditingController(
    text:
        'Rua das Acácias, 450 - Centro Comunitário Vila Nova, São Paulo - SP',
  );
  final _pixKeyController = TextEditingController(
    text: 'associacao.vilanova@comunidade.org.br',
  );
  final _financialGoalController = TextEditingController(text: '4.500,00');

  String _selectedCategory = 'Reforma Comunitária';
  String _selectedUrgency = 'Alta Prioridade';
  bool _agreedTerms = true;
  bool _isPublishing = false;

  final List<Map<String, dynamic>> _items = [
    {
      'name': 'Sacos de Cimento CP-II',
      'qty': 15,
      'unit': 'Sacos',
    },
    {
      'name': 'Tinta Acrílica para Piso Azul',
      'qty': 4,
      'unit': 'Latas',
    },
    {
      'name': 'Redes Oficiais para Trave e Aros',
      'qty': 2,
      'unit': 'Unidades',
    },
  ];

  final List<String> _categories = [
    'Alimentação',
    'Roupas',
    'Reforma Comunitária',
    'Educação',
    'Apoio a Idosos',
    'Emergência Climática',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _pixKeyController.dispose();
    _financialGoalController.dispose();
    super.dispose();
  }

  void _addNewItem() {
    setState(() {
      _items.add({
        'name': 'Novo Item',
        'qty': 10,
        'unit': 'Unidades',
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _publishCampaign() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe o título da campanha.'),
          backgroundColor: FluentTheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isPublishing = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final state = context.read<AppState>();
    state.addNewCampaign(
      title: title,
      subtitle: _descController.text.trim(),
      category: _selectedCategory,
      location: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : 'São Paulo, SP',
      targetLabel: 'Meta: ${_items.length} itens essenciais',
    );

    setState(() {
      _isPublishing = false;
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
          side: const BorderSide(color: FluentTheme.border),
        ),
        backgroundColor: FluentTheme.cardBg,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: FluentTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
              ),
              child: const Icon(
                Icons.check_circle,
                color: FluentTheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Campanha Publicada!',
              style: FluentTheme.subheading.copyWith(
                color: FluentTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Sua campanha "$title" já está ativa no feed comunitário para receber apoio e doações.',
          style: FluentTheme.body.copyWith(color: FluentTheme.textSecondary),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FluentTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
              ),
            ),
            child: Text('Ver no Feed', style: FluentTheme.captionBold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Breadcrumb / Status
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
              border: Border.all(color: FluentTheme.border),
              boxShadow: FluentTheme.cardShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              'Painel do Organizador',
                              style: FluentTheme.captionBold.copyWith(
                                color: FluentTheme.accent,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '/',
                              style: TextStyle(color: FluentTheme.textTertiary),
                            ),
                            const SizedBox(width: 6),
                            Text('Etapa 1 de 4', style: FluentTheme.caption),
                            const SizedBox(width: 6),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: FluentTheme.textTertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Rascunho salvo automaticamente',
                              style: FluentTheme.caption.copyWith(
                                color: FluentTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Criar Nova Campanha Comunitária',
                        style: FluentTheme.heading.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cadastre uma causa local, conecte vizinhos e receba mantimentos e apoio financeiro com total transparência.',
                        style: FluentTheme.body.copyWith(
                          color: FluentTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: FluentTheme.border),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            FluentTheme.radiusSm,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: FluentTheme.textSecondary,
                      ),
                      label: Text(
                        'Modo Visualizador',
                        style: FluentTheme.captionBold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Rascunho salvo com sucesso!'),
                            backgroundColor: FluentTheme.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                FluentTheme.radiusSm,
                              ),
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: FluentTheme.border),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            FluentTheme.radiusSm,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.bookmark_border,
                        size: 16,
                        color: FluentTheme.textSecondary,
                      ),
                      label: Text(
                        'Salvar Rascunho',
                        style: FluentTheme.captionBold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stepper / Linear steps Windows 11
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
              border: Border.all(color: FluentTheme.border),
              boxShadow: FluentTheme.cardShadow,
            ),
            child: Row(
              children: [
                _buildStepperItem('1', 'Dados Básicos', 'Em preenchimento', true),
                const SizedBox(width: 8),
                _buildStepperItem('2', 'Itens & Metas', '${_items.length} itens adicionados', false),
                const SizedBox(width: 8),
                _buildStepperItem('3', 'Fotos & Mídia', 'Galeria da causa', false),
                const SizedBox(width: 8),
                _buildStepperItem('4', 'Entrega & Pix', 'Ponto de coleta', false),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Grid Principal: Formulário (8) + Lateral Preview (4)
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 980;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 8, child: _buildForm(context)),
                        const SizedBox(width: 20),
                        Expanded(flex: 4, child: _buildPreviewPane(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildForm(context),
                        const SizedBox(height: 20),
                        _buildPreviewPane(context),
                      ],
                    );
            },
          ),
          const SizedBox(height: 24),

          // Barra de Comando Inferior Fixa Fluent
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
              border: Border.all(color: FluentTheme.border),
              boxShadow: FluentTheme.cardShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cloud_done_outlined,
                        color: FluentTheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alterações salvas automaticamente no rascunho',
                              style: FluentTheme.captionBold.copyWith(
                                color: FluentTheme.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Você poderá editar estas informações após a publicação.',
                              style: FluentTheme.caption,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: FluentTheme.border),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            FluentTheme.radiusSm,
                          ),
                        ),
                      ),
                      child: Text('Cancelar', style: FluentTheme.captionBold),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _isPublishing ? null : _publishCampaign,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FluentTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            FluentTheme.radiusSm,
                          ),
                        ),
                      ),
                      icon: _isPublishing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send, size: 16),
                      label: Text(
                        _isPublishing ? 'Publicando...' : 'Publicar Campanha',
                        style: FluentTheme.captionBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperItem(
    String stepNum,
    String title,
    String subtitle,
    bool isActive,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEDF7ED) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border(
            left: BorderSide(
              color: isActive ? FluentTheme.primary : Colors.transparent,
              width: 3.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isActive ? FluentTheme.primary : FluentTheme.hoverBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? FluentTheme.primary : FluentTheme.border,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                stepNum,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : FluentTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FluentTheme.captionBold.copyWith(
                      color: isActive
                          ? FluentTheme.primary
                          : FluentTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: FluentTheme.caption.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        // Bloco 1: Informações Essenciais da Causa
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: FluentTheme.cardBg,
            borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
            border: Border.all(color: FluentTheme.border),
            boxShadow: FluentTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 16,
                          decoration: BoxDecoration(
                            color: FluentTheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '1. Informações Essenciais da Causa',
                            style: FluentTheme.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: FluentTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF7ED),
                      border: Border.all(color: const Color(0xFFBCE8BB)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Passo Principal',
                      style: FluentTheme.captionBold.copyWith(
                        color: FluentTheme.primary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Título da Campanha ',
                      style: FluentTheme.captionBold.copyWith(
                        color: FluentTheme.textPrimary,
                      ),
                      children: const [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: FluentTheme.error),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_titleController.text.length}/80',
                    style: FluentTheme.caption,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _titleController,
                maxLength: 80,
                buildCounter: (
                  _, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) => null,
                style: FluentTheme.body,
                decoration: InputDecoration(
                  hintText: 'ex: Reforma da Quadra Esportiva Vila Nova',
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                    borderSide: const BorderSide(color: FluentTheme.border),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 4),
              Text(
                'Escolha um nome objetivo e afetuoso que mostre exatamente o local e a melhoria esperada.',
                style: FluentTheme.caption,
              ),
              const SizedBox(height: 16),

              // Categoria Principal
              RichText(
                text: TextSpan(
                  text: 'Categoria Principal ',
                  style: FluentTheme.captionBold.copyWith(
                    color: FluentTheme.textPrimary,
                  ),
                  children: const [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: FluentTheme.error),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEDF7ED)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? FluentTheme.primary
                              : FluentTheme.border,
                        ),
                        borderRadius: BorderRadius.circular(
                          FluentTheme.radiusSm,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(cat),
                            size: 15,
                            color: isSelected
                                ? FluentTheme.primary
                                : FluentTheme.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? FluentTheme.primary
                                  : FluentTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Nível de Urgência
              RichText(
                text: TextSpan(
                  text: 'Nível de Urgência ',
                  style: FluentTheme.captionBold.copyWith(
                    color: FluentTheme.textPrimary,
                  ),
                  children: const [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: FluentTheme.error),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildUrgencyOption(
                    'Normal',
                    'Prazo de 30 a 60 dias para captação contínua.',
                    FluentTheme.textPrimary,
                  ),
                  const SizedBox(width: 8),
                  _buildUrgencyOption(
                    'Alta Prioridade',
                    'Necessidade dentro de 1 a 2 semanas.',
                    FluentTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  _buildUrgencyOption(
                    'Emergencial',
                    'Desastres ou auxílio urgente até 72h.',
                    FluentTheme.error,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // História & Detalhes
              RichText(
                text: TextSpan(
                  text: 'História & Detalhes da Campanha ',
                  style: FluentTheme.captionBold.copyWith(
                    color: FluentTheme.textPrimary,
                  ),
                  children: const [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: FluentTheme.error),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: FluentTheme.border),
                  borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: FluentTheme.hoverBg,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.format_bold, size: 16),
                            onPressed: () {},
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                          ),
                          IconButton(
                            icon: const Icon(Icons.format_italic, size: 16),
                            onPressed: () {},
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.format_list_bulleted,
                              size: 16,
                            ),
                            onPressed: () {},
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Dica: Escreva com clareza, informando quem será beneficiado.',
                              style: FluentTheme.caption.copyWith(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _descController,
                      maxLines: 4,
                      style: FluentTheme.body,
                      decoration: const InputDecoration(
                        hintText: 'Conte a história da ação...',
                        contentPadding: EdgeInsets.all(12),
                        border: InputBorder.none,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Bloco 2: Itens que você precisa arrecadar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: FluentTheme.cardBg,
            borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
            border: Border.all(color: FluentTheme.border),
            boxShadow: FluentTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 16,
                          decoration: BoxDecoration(
                            color: FluentTheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2. Itens que você precisa arrecadar',
                                style: FluentTheme.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: FluentTheme.textPrimary,
                                ),
                              ),
                              Text(
                                'Especifique materiais físicos ou mantimentos para doações diretas.',
                                style: FluentTheme.caption,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _addNewItem,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: FluentTheme.border),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          FluentTheme.radiusSm,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                      size: 16,
                      color: FluentTheme.primary,
                    ),
                    label: Text(
                      'Adicionar Novo Item',
                      style: FluentTheme.captionBold.copyWith(
                        color: FluentTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Table
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: FluentTheme.border),
                  borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: FluentTheme.hoverBg,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              'DESCRIÇÃO DO ITEM / MANTIMENTO',
                              style: FluentTheme.captionBold.copyWith(
                                fontSize: 10,
                                color: FluentTheme.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'QUANTIDADE',
                              style: FluentTheme.captionBold.copyWith(
                                fontSize: 10,
                                color: FluentTheme.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'UNIDADE',
                              style: FluentTheme.captionBold.copyWith(
                                fontSize: 10,
                                color: FluentTheme.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                        ],
                      ),
                    ),
                    ..._items.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: FluentTheme.border),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Text(
                                item['name'] as String,
                                style: FluentTheme.captionBold.copyWith(
                                  color: FluentTheme.textPrimary,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${item['qty']}',
                                style: FluentTheme.body,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                item['unit'] as String,
                                style: FluentTheme.caption,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: FluentTheme.error,
                              ),
                              onPressed: () => _removeItem(idx),
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(6),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 16,
                        color: FluentTheme.accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Total mapeado: ${_items.length} itens para arrecadação física',
                        style: FluentTheme.captionBold,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFF6DD),
                      border: Border.all(color: const Color(0xFFBCE8BB)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '100% monitorado',
                      style: FluentTheme.captionBold.copyWith(
                        color: FluentTheme.primary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Bloco 3: Fotos & Dropzone
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: FluentTheme.cardBg,
            borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
            border: Border.all(color: FluentTheme.border),
            boxShadow: FluentTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: FluentTheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3. Fotos da Causa & Divulgação',
                        style: FluentTheme.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: FluentTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Campanhas com imagens reais do local arrecadam 3x mais rápido.',
                        style: FluentTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),

              // Dropzone
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: FluentTheme.hoverBg,
                  border: Border.all(
                    color: FluentTheme.border,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: FluentTheme.border),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        color: FluentTheme.textSecondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Arraste fotos aqui ou clique para selecionar',
                      style: FluentTheme.captionBold.copyWith(
                        color: FluentTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Formatos PNG, JPG e WEBP até 10MB. Recomenda-se orientação horizontal (16:9).',
                      style: FluentTheme.caption,
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: FluentTheme.border),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            FluentTheme.radiusSm,
                          ),
                        ),
                      ),
                      child: Text(
                        'Procurar Arquivos no Computador',
                        style: FluentTheme.captionBold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Thumbnails
              Row(
                children: [
                  _buildPhotoThumbnail(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDgtKSQOmpanDcaDgTseEuewy3Tk14XV9ADjrpArmqS5DnTjZacCYIUqIPHkt2gLaFs_T3nwmVrKt-N9RkKSHAm2XFkw4AAVhMydgyMBuO48V9nmXh7G1xNucg3BSjEUBadd5VxvNQAAPpt6qB2aHhFyEezihL3fdFdH79zCYEKnanCRroPNnMD65cZni2Ipp4MYX4QJbqRWfrb6ScpqCqIx7_vOFBdQIuN0aW-OEQ',
                    isCover: true,
                  ),
                  const SizedBox(width: 8),
                  _buildPhotoThumbnail(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuD1dpiyk0HF-UDvo3SiA2rAIYnrgAp5_3i33EHxnS-2DnmOPbtoAtP5Bp5Q1d6gumSCdn9IT6VRP-rwwcEYetE-Gftq-RklyQQFVJXLcyhKbWosE0f1n-i9n4VHqp_M4KyCAYCjA83Xb2zuTM1i7tGk9D_6vUVBVFzZpoy4mZym7JLMw-GuHWfoSGsRc0F313RO4jMoMGip2oNFmeCyI_v2MHqCVDxQWH6tpuTrARc',
                  ),
                  const SizedBox(width: 8),
                  _buildPhotoThumbnail(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA7oGbQ2Ym9DJ-nFvm-tBZ6TcAR5pGfpMmR8p4qBCf44JfFoVNmO1xNTHn3GiQZfWqOlj8Yn4E4SAFC4sbvs-XSVJq11M_jYfLGjy6H_XW7jkAT6YqfD50HSn4oP-fGCNE3q06UhiTxmMaawjjd0dIHuyQ_18UeKSRGC6Mcu9wU20eyaHldGtHAE_rCmnsYnS1un9aMn2VxktdoIT5jkKH0Xjy7xLf5hwTiztch2FY',
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: FluentTheme.hoverBg,
                        border: Border.all(color: FluentTheme.border),
                        borderRadius: BorderRadius.circular(
                          FluentTheme.radiusSm,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 18,
                            color: FluentTheme.textSecondary,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+ Adicionar',
                            style: FluentTheme.captionBold.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Bloco 4: Ponto Oficial & Pix
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: FluentTheme.cardBg,
            borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
            border: Border.all(color: FluentTheme.border),
            boxShadow: FluentTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: FluentTheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '4. Ponto de Coleta & Apoio Financeiro Seguro',
                        style: FluentTheme.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: FluentTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Facilite a entrega presencial e permita doações imediatas via Pix.',
                        style: FluentTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),

              // Endereço
              RichText(
                text: TextSpan(
                  text: 'Endereço Físico do Ponto de Coleta ',
                  style: FluentTheme.captionBold.copyWith(
                    color: FluentTheme.textPrimary,
                  ),
                  children: const [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: FluentTheme.error),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _addressController,
                style: FluentTheme.body,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.pin_drop_outlined,
                    size: 18,
                    color: FluentTheme.textSecondary,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                    borderSide: const BorderSide(color: FluentTheme.border),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 4),
              Text(
                'Horário de recebimento: Seg a Sex das 08h às 18h e Sábados das 09h às 14h.',
                style: FluentTheme.caption,
              ),
              const SizedBox(height: 16),

              // Chave Pix & Meta
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Chave Pix da Associação ',
                            style: FluentTheme.captionBold.copyWith(
                              color: FluentTheme.textPrimary,
                            ),
                            children: const [
                              TextSpan(
                                text: '*',
                                style: TextStyle(color: FluentTheme.error),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _pixKeyController,
                          style: FluentTheme.body,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.qr_code_2,
                              size: 18,
                              color: FluentTheme.textSecondary,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                FluentTheme.radiusSm,
                              ),
                              borderSide: const BorderSide(
                                color: FluentTheme.border,
                              ),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meta Financeira Estimada (Opcional)',
                          style: FluentTheme.captionBold,
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _financialGoalController,
                          style: FluentTheme.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              child: Text(
                                'R\$',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: FluentTheme.textSecondary,
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                FluentTheme.radiusSm,
                              ),
                              borderSide: const BorderSide(
                                color: FluentTheme.border,
                              ),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Termos
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FluentTheme.hoverBg,
                  borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                  border: Border.all(color: FluentTheme.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreedTerms,
                      activeColor: FluentTheme.accent,
                      onChanged: (val) =>
                          setState(() => _agreedTerms = val ?? false),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Comprometo-me a prestar contas publicamente de todos os itens recebidos e notas fiscais de compras financeiras através da aba de Impacto & Transparência da Comunidade em Ação.',
                        style: FluentTheme.caption.copyWith(
                          color: FluentTheme.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUrgencyOption(String title, String desc, Color color) {
    final isSelected = _selectedUrgency == title;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedUrgency = title;
          });
        },
        borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEDF7ED) : Colors.white,
            border: Border.all(
              color: isSelected ? color : FluentTheme.border,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: title,
                    groupValue: _selectedUrgency,
                    activeColor: color,
                    onChanged: (val) => setState(() => _selectedUrgency = val!),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : FluentTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Text(
                  desc,
                  style: FluentTheme.caption.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail(String url, {bool isCover = false}) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
              border: Border.all(color: FluentTheme.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomImage(
              url: url,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          if (isCover)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: FluentTheme.border),
                ),
                child: const Text(
                  'Capa',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviewPane(BuildContext context) {
    return Column(
      children: [
        // Live Preview Feed Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: FluentTheme.cardBg,
            borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
            border: Border.all(color: FluentTheme.border),
            boxShadow: FluentTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.preview,
                        size: 16,
                        color: FluentTheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Pré-visualização do Feed',
                        style: FluentTheme.captionBold.copyWith(
                          color: FluentTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: FluentTheme.hoverBg,
                      border: Border.all(color: FluentTheme.border),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'Ao Vivo',
                      style: FluentTheme.caption.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Assim que os vizinhos e doadores visualizarão a sua campanha no mural comunitário:',
                style: FluentTheme.caption,
              ),
              const SizedBox(height: 12),

              // Mock Card
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: FluentTheme.border),
                  borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        const SizedBox(
                          height: 130,
                          width: double.infinity,
                          child: CustomImage(
                            url:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuDgtKSQOmpanDcaDgTseEuewy3Tk14XV9ADjrpArmqS5DnTjZacCYIUqIPHkt2gLaFs_T3nwmVrKt-N9RkKSHAm2XFkw4AAVhMydgyMBuO48V9nmXh7G1xNucg3BSjEUBadd5VxvNQAAPpt6qB2aHhFyEezihL3fdFdH79zCYEKnanCRroPNnMD65cZni2Ipp4MYX4QJbqRWfrb6ScpqCqIx7_vOFBdQIuN0aW-OEQ',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Text(
                              _selectedUrgency,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: _selectedUrgency == 'Emergencial'
                                    ? FluentTheme.error
                                    : FluentTheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 8,
                          right: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.55),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  _selectedCategory,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    _addressController.text.contains(',')
                                        ? _addressController.text.split(',')[0]
                                        : 'São Paulo',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: FluentTheme.border,
                                child: Text(
                                  'A',
                                  style: FluentTheme.captionBold.copyWith(
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Por Você • Agora mesmo',
                                style: FluentTheme.caption.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _titleController.text.trim().isNotEmpty
                                ? _titleController.text.trim()
                                : 'Título da sua Campanha Comunitária',
                            style: FluentTheme.captionBold.copyWith(
                              fontSize: 13,
                              color: FluentTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _descController.text.trim(),
                            style: FluentTheme.caption.copyWith(fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progresso Físico',
                                style: FluentTheme.caption.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                '0 de ${_items.length} itens',
                                style: FluentTheme.captionBold.copyWith(
                                  color: FluentTheme.primary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: 0.1,
                              backgroundColor: FluentTheme.hoverBg,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                FluentTheme.primary,
                              ),
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Meta Pix: R\$ ${_financialGoalController.text}',
                                style: FluentTheme.caption.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                'Iniciando',
                                style: FluentTheme.captionBold.copyWith(
                                  color: FluentTheme.primary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: FluentTheme.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    FluentTheme.radiusSm,
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                Icons.volunteer_activism,
                                size: 14,
                              ),
                              label: Text(
                                'Apoiar Esta Causa',
                                style: FluentTheme.captionBold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Dicas para Aprovação Rápida
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: FluentTheme.cardBg,
            borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
            border: Border.all(color: FluentTheme.border),
            boxShadow: FluentTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.help_outline,
                    size: 16,
                    color: FluentTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Dicas para Aprovação Rápida',
                    style: FluentTheme.captionBold.copyWith(
                      color: FluentTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              _buildTipRow(
                'Fotos Nítidas:',
                'Imagens reais e bem iluminadas aumentam em 4x a credibilidade.',
              ),
              const SizedBox(height: 8),
              _buildTipRow(
                'Metas Realistas:',
                'Liste itens fracionados fáceis de doar por uma pessoa.',
              ),
              const SizedBox(height: 8),
              _buildTipRow(
                'Ponto de Coleta Acessível:',
                'Defina um local público de referência segura no bairro.',
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FluentTheme.hoverBg,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: FluentTheme.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tempo de moderação estimado:', style: FluentTheme.caption),
                    Text(
                      '< 15 minutos',
                      style: FluentTheme.captionBold.copyWith(
                        color: FluentTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipRow(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          size: 14,
          color: FluentTheme.primary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$title ',
              style: FluentTheme.captionBold.copyWith(
                color: FluentTheme.textPrimary,
                fontSize: 11,
              ),
              children: [
                TextSpan(
                  text: desc,
                  style: FluentTheme.caption.copyWith(
                    color: FluentTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Alimentação':
        return Icons.restaurant;
      case 'Roupas':
        return Icons.checkroom;
      case 'Reforma Comunitária':
        return Icons.handyman;
      case 'Educação':
        return Icons.school;
      case 'Apoio a Idosos':
        return Icons.elderly;
      case 'Emergência Climática':
        return Icons.flood;
      default:
        return Icons.volunteer_activism;
    }
  }
}


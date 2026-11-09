import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/fluent_theme.dart';

class WindowsDonateView extends StatefulWidget {
  final Campaign campaign;
  final VoidCallback onBackToFeed;
  final VoidCallback onBackToDetails;
  final bool startOnPix;

  const WindowsDonateView({
    super.key,
    required this.campaign,
    required this.onBackToFeed,
    required this.onBackToDetails,
    this.startOnPix = false,
  });

  @override
  State<WindowsDonateView> createState() => _WindowsDonateViewState();
}

class _WindowsDonateViewState extends State<WindowsDonateView> {
  int _selectedPixValue = 50;
  final TextEditingController _customPixController = TextEditingController();
  bool _copiedPix = false;

  @override
  void dispose() {
    _customPixController.dispose();
    super.dispose();
  }

  void _copyPixKey(String key) {
    Clipboard.setData(ClipboardData(text: key));
    setState(() {
      _copiedPix = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Chave Pix copiada com sucesso para a área de transferência!'),
          ],
        ),
        backgroundColor: FluentTheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _copiedPix = false;
        });
      }
    });
  }

  void _confirmDonation(BuildContext context, AppState state) {
    final record = state.confirmCurrentDonation(campaign: widget.campaign);

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
              'Doação Registrada!',
              style: FluentTheme.subheading.copyWith(
                color: FluentTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sua intenção de doação para "${widget.campaign.title}" foi gerada com sucesso no sistema.',
                style: FluentTheme.body.copyWith(
                  color: FluentTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FluentTheme.hoverBg,
                  borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                  border: Border.all(color: FluentTheme.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Código do Comprovante:', style: FluentTheme.caption),
                        Text(
                          record.receiptCode,
                          style: FluentTheme.body.copyWith(
                            fontWeight: FontWeight.bold,
                            color: FluentTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Modalidade:', style: FluentTheme.caption),
                        Text(
                          record.deliveryMethod,
                          style: FluentTheme.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: FluentTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Endereço:', style: FluentTheme.caption),
                        Expanded(
                          child: Text(
                            record.address ?? 'Ponto Oficial de Coleta',
                            textAlign: TextAlign.end,
                            style: FluentTheme.caption.copyWith(
                              color: FluentTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enviamos as orientações e o recibo digital para o seu e-mail cadastrado.',
                style: FluentTheme.caption.copyWith(
                  color: FluentTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onBackToDetails();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: FluentTheme.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
              ),
            ),
            child: Text('Ver Detalhes', style: FluentTheme.captionBold),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onBackToFeed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FluentTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
              ),
            ),
            child: Text('Voltar ao Mural', style: FluentTheme.captionBold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final campaign = widget.campaign;
    final totalItems = state.totalSelectedItemsCount;
    final estimatedWeight = totalItems * 1.8;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb Navigation
          Row(
            children: [
              InkWell(
                onTap: widget.onBackToDetails,
                borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: FluentTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Voltar para Detalhes',
                        style: FluentTheme.body.copyWith(
                          color: FluentTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('/', style: TextStyle(color: FluentTheme.textTertiary)),
              const SizedBox(width: 8),
              Text(
                'Registrar Doação',
                style: FluentTheme.body.copyWith(
                  color: FluentTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Header Contextual com Barra de Passos
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: FluentTheme.cardBg,
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
              border: Border.all(color: FluentTheme.border),
              boxShadow: FluentTheme.cardShadow,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.eco,
                            size: 16,
                            color: FluentTheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Campanha Ativa • ${campaign.organizationName}',
                            style: FluentTheme.captionBold.copyWith(
                              color: FluentTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Doação para ${campaign.title}',
                        style: FluentTheme.heading.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Escolha como apoiar: doe alimentos prioritários para as famílias ou contribua instantaneamente via Pix.',
                        style: FluentTheme.body.copyWith(
                          color: FluentTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Fluent Stepper
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: FluentTheme.hoverBg,
                    border: Border.all(color: FluentTheme.border),
                    borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: FluentTheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Escolher Doação',
                        style: FluentTheme.captionBold.copyWith(
                          color: FluentTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 24,
                        height: 1,
                        color: FluentTheme.border,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: FluentTheme.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '2',
                          style: TextStyle(
                            color: FluentTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Entrega & Recibo',
                        style: FluentTheme.caption.copyWith(
                          color: FluentTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Painel Split Grid Lado a Lado (7 cols + 5 cols)
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 950;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: _buildItemsPanel(context, state, campaign),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 5,
                          child: _buildPixPanel(context, campaign),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildItemsPanel(context, state, campaign),
                        const SizedBox(height: 20),
                        _buildPixPanel(context, campaign),
                      ],
                    );
            },
          ),
          const SizedBox(height: 24),

          // Rodapé Nativo Command Bar Fluent
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
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: FluentTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: FluentTheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: FluentTheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total selecionado: $totalItems ${totalItems == 1 ? "item" : "itens"}',
                              style: FluentTheme.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: FluentTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: FluentTheme.hoverBg,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: FluentTheme.border),
                              ),
                              child: Text(
                                'Físico',
                                style: FluentTheme.caption.copyWith(
                                  fontSize: 10,
                                  color: FluentTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.scale_outlined,
                              size: 13,
                              color: FluentTheme.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Estimativa de peso: ~${estimatedWeight.toStringAsFixed(1)} kg',
                              style: FluentTheme.caption.copyWith(
                                color: FluentTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Rascunho de doação salvo com sucesso!'),
                            backgroundColor: FluentTheme.textPrimary,
                            duration: const Duration(seconds: 2),
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
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            FluentTheme.radiusSm,
                          ),
                        ),
                      ),
                      child: Text('Salvar Rascunho', style: FluentTheme.captionBold),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: totalItems > 0
                          ? () => _confirmDonation(context, state)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FluentTheme.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: FluentTheme.border,
                        disabledForegroundColor: FluentTheme.textTertiary,
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
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: Text(
                        'Confirmar e Registrar Doação',
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

  Widget _buildItemsPanel(
    BuildContext context,
    AppState state,
    Campaign campaign,
  ) {
    return Container(
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
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: FluentTheme.hoverBg,
                      border: Border.all(color: FluentTheme.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: FluentTheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doação de Alimentos e Mantimentos',
                        style: FluentTheme.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: FluentTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Selecione os mantimentos que você deseja entregar',
                        style: FluentTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF6E6),
                  border: Border.all(color: const Color(0xFFF5DCA3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Alta Prioridade',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8F4F00),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tabela / Lista Interativa Fluent
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: FluentTheme.border),
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: FluentTheme.hoverBg,
                    border: Border(
                      bottom: BorderSide(color: FluentTheme.border),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ITEM E META RESTANTE',
                        style: FluentTheme.captionBold.copyWith(
                          fontSize: 11,
                          color: FluentTheme.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'QUANTIDADE',
                          style: FluentTheme.captionBold.copyWith(
                            fontSize: 11,
                            color: FluentTheme.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Rows
                ...campaign.needItems.map((item) {
                  final qty = state.itemQuantities[item.id] ?? 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: FluentTheme.border),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: FluentTheme.hoverBg,
                                border: Border.all(color: FluentTheme.border),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                _mapItemIcon(item.iconType),
                                size: 18,
                                color: FluentTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.name} (${item.unitDescription})',
                                  style: FluentTheme.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: FluentTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      'Meta restante: ',
                                      style: FluentTheme.caption,
                                    ),
                                    Text(
                                      item.metaRemainingText,
                                      style: FluentTheme.captionBold.copyWith(
                                        color: FluentTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Numeric Stepper
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: FluentTheme.border),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => state.updateItemQuantity(item.id, -1),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.remove,
                                    size: 14,
                                    color: FluentTheme.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                width: 34,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  border: Border.symmetric(
                                    vertical: BorderSide(
                                      color: FluentTheme.border,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '$qty',
                                  style: FluentTheme.captionBold.copyWith(
                                    color: FluentTheme.textPrimary,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => state.updateItemQuantity(item.id, 1),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.add,
                                    size: 14,
                                    color: FluentTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Opções de Envio / Logística
          Text(
            'Forma de Entrega dos Alimentos:',
            style: FluentTheme.captionBold.copyWith(
              fontSize: 13,
              color: FluentTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => state.setDeliveryMethod('point'),
                  borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: state.selectedDeliveryMethod == 'point'
                          ? const Color(0xFFF8FCF9)
                          : Colors.white,
                      border: Border.all(
                        color: state.selectedDeliveryMethod == 'point'
                            ? FluentTheme.primary
                            : FluentTheme.border,
                        width: state.selectedDeliveryMethod == 'point' ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(
                        FluentTheme.radiusCard,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio<String>(
                          value: 'point',
                          groupValue: state.selectedDeliveryMethod,
                          activeColor: FluentTheme.primary,
                          onChanged: (val) => state.setDeliveryMethod('point'),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 15,
                                    color: FluentTheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Entregar no ponto de coleta',
                                    style: FluentTheme.captionBold.copyWith(
                                      color: FluentTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Rua das Flores, 120 - Heliópolis, SP',
                                style: FluentTheme.caption,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Segunda a Sábado, das 8h às 18h',
                                style: FluentTheme.captionBold.copyWith(
                                  color: FluentTheme.primary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => state.setDeliveryMethod('pickup'),
                  borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: state.selectedDeliveryMethod == 'pickup'
                          ? const Color(0xFFF8FCF9)
                          : Colors.white,
                      border: Border.all(
                        color: state.selectedDeliveryMethod == 'pickup'
                            ? FluentTheme.primary
                            : FluentTheme.border,
                        width: state.selectedDeliveryMethod == 'pickup' ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(
                        FluentTheme.radiusCard,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio<String>(
                          value: 'pickup',
                          groupValue: state.selectedDeliveryMethod,
                          activeColor: FluentTheme.primary,
                          onChanged: (val) => state.setDeliveryMethod('pickup'),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_shipping,
                                    size: 15,
                                    color: FluentTheme.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Agendar retirada em casa',
                                    style: FluentTheme.captionBold.copyWith(
                                      color: FluentTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Voluntário credenciado recolhe no seu endereço',
                                style: FluentTheme.caption,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Disponível em raio de até 15 km',
                                style: FluentTheme.caption.copyWith(
                                  color: FluentTheme.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPixPanel(BuildContext context, Campaign campaign) {
    final pixKey = campaign.pixKey ?? 'f89b1c94-73d8-4f1a-b601-heliopolis024';

    return Container(
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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: FluentTheme.hoverBg,
                  border: Border.all(color: FluentTheme.border),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: FluentTheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ou Apoiar com Pix Instantâneo',
                    style: FluentTheme.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: FluentTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Garante a compra direta de hortaliças frescas',
                    style: FluentTheme.caption,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Seletor de Valor Rápido
          Text('Selecione o valor sugerido:', style: FluentTheme.caption),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.3,
            children: [
              _buildPixPresetBtn(20, '1 kit básico'),
              _buildPixPresetBtn(50, 'Meia cesta familiar'),
              _buildPixPresetBtn(100, '1 cesta completa'),
              _buildPixPresetBtn(200, 'Família completa / mês'),
            ],
          ),
          const SizedBox(height: 8),

          // Outro valor input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: FluentTheme.hoverBg,
              border: Border.all(color: FluentTheme.border),
              borderRadius: BorderRadius.circular(FluentTheme.radiusSm),
            ),
            child: Row(
              children: [
                Text(
                  'Outro valor:',
                  style: FluentTheme.caption.copyWith(
                    color: FluentTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'R\$',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: FluentTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: _customPixController,
                    keyboardType: TextInputType.number,
                    style: FluentTheme.body.copyWith(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: '0,00',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 6),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        setState(() {
                          _selectedPixValue = 0;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // QR Code Card Fluent
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FluentTheme.hoverBg,
              border: Border.all(color: FluentTheme.border),
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: FluentTheme.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      // Sharp QR Code mockup with icon in middle
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.qr_code_2,
                              size: 130,
                              color: FluentTheme.textPrimary,
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.pix,
                                size: 20,
                                color: FluentTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PIX BANCO CENTRAL',
                        style: FluentTheme.captionBold.copyWith(
                          fontSize: 10,
                          color: FluentTheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Chave Pix Aleatória:', style: FluentTheme.caption),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: FluentTheme.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          pixKey,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: FluentTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () => _copyPixKey(pixKey),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _copiedPix
                                ? FluentTheme.primary.withOpacity(0.12)
                                : FluentTheme.hoverBg,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _copiedPix ? Icons.check : Icons.copy,
                                size: 13,
                                color: FluentTheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _copiedPix ? 'Copiado!' : 'Copiar',
                                style: FluentTheme.captionBold.copyWith(
                                  color: FluentTheme.primary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Como Funciona 3 passos
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FluentTheme.hoverBg,
              border: Border.all(color: FluentTheme.border),
              borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COMO FUNCIONA:',
                  style: FluentTheme.captionBold.copyWith(
                    fontSize: 10,
                    color: FluentTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPixStep('1', 'Abra o app do seu banco'),
                    _buildPixStep('2', 'Escaneie ou cole o código'),
                    _buildPixStep('3', 'Confirmação instantânea'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPixPresetBtn(int value, String subtitle) {
    final isSelected = _selectedPixValue == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPixValue = value;
          _customPixController.clear();
        });
      },
      borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F8F4) : Colors.white,
          border: Border.all(
            color: isSelected ? FluentTheme.primary : FluentTheme.border,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(FluentTheme.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'R\$ $value',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? FluentTheme.primary : FluentTheme.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? FluentTheme.primaryDark : FluentTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPixStep(String stepNumber, String stepText) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: FluentTheme.border),
              borderRadius: BorderRadius.circular(3),
            ),
            alignment: Alignment.center,
            child: Text(
              stepNumber,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: FluentTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stepText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: FluentTheme.textSecondary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  IconData _mapItemIcon(String iconType) {
    switch (iconType) {
      case 'grain':
        return Icons.grain;
      case 'soup_kitchen':
        return Icons.soup_kitchen;
      case 'water_bottle':
        return Icons.water_drop_outlined;
      case 'local_drink':
        return Icons.local_drink;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'format_paint':
        return Icons.format_paint;
      case 'cable':
        return Icons.cable;
      case 'backpack':
        return Icons.backpack;
      default:
        return Icons.inventory_2_outlined;
    }
  }
}


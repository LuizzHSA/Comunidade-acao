import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class PixModal extends StatefulWidget {
  final String pixKey;
  final String campaignTitle;

  const PixModal({
    super.key,
    required this.pixKey,
    required this.campaignTitle,
  });

  static Future<void> show(
    BuildContext context, {
    required String pixKey,
    required String campaignTitle,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PixModal(
        pixKey: pixKey,
        campaignTitle: campaignTitle,
      ),
    );
  }

  @override
  State<PixModal> createState() => _PixModalState();
}

class _PixModalState extends State<PixModal> {
  int _selectedAmount = 50;
  bool _copied = false;
  final TextEditingController _customAmountController = TextEditingController();

  void _copyPixKey() {
    Clipboard.setData(ClipboardData(text: widget.pixKey));
    setState(() {
      _copied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.secondaryFixed, size: 20),
            SizedBox(width: 8),
            Text(
              'Chave Pix copiada com sucesso!',
              style: TextStyle(
                color: AppTheme.inverseOnSurface,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
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
                  color: AppTheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                ),
                child: const Icon(
                  Icons.qr_code_2,
                  color: AppTheme.onSecondaryContainer,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doação com Pix',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      widget.campaignTitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
            'Selecione um valor para doação:',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [20, 50, 100].map((amount) {
              final isSelected = _selectedAmount == amount;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppTheme.primaryContainer
                          : AppTheme.surfaceContainerLow,
                      foregroundColor: isSelected
                          ? AppTheme.onPrimary
                          : AppTheme.onSurface,
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryContainer
                            : AppTheme.outlineVariant.withOpacity(0.4),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedAmount = amount;
                      });
                    },
                    child: Text(
                      'R\$ $amount',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
              border: Border.all(
                color: AppTheme.outlineVariant.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chave Pix Oficial',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.onSurfaceVariant,
                          ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.shield, size: 14, color: AppTheme.secondary),
                        SizedBox(width: 4),
                        Text(
                          'Transparência Garantida',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  widget.pixKey,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurface,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _copied
                  ? AppTheme.secondaryContainer
                  : AppTheme.primaryContainer,
              foregroundColor: _copied
                  ? AppTheme.onSecondaryContainer
                  : AppTheme.onPrimary,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
              ),
            ),
            onPressed: _copyPixKey,
            icon: Icon(
              _copied ? Icons.check : Icons.copy,
              size: 20,
            ),
            label: Text(
              _copied ? 'Chave Pix Copiada!' : 'Copiar Chave Pix',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';

import '../mock/mock_candidaturas.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_card.dart';
import '../widgets/app_header.dart';
import '../widgets/icon_avatar_box.dart';
import '../widgets/staggered_list_item.dart';
import '../widgets/status_badge.dart';

/// Tela de acompanhamento das candidaturas do usuário.
class CandidaturasScreen extends StatefulWidget {
  const CandidaturasScreen({this.onNavigationItemSelected, super.key});

  final ValueChanged<int>? onNavigationItemSelected;

  @override
  State<CandidaturasScreen> createState() => _CandidaturasScreenState();
}

class _CandidaturasScreenState extends State<CandidaturasScreen> {
  static const _filtros = <({String label, CandidaturaStatus? status})>[
    (label: 'Todas (4)', status: null),
    (label: 'Em análise (2)', status: CandidaturaStatus.emAnalise),
    (label: 'Selecionado (1)', status: CandidaturaStatus.selecionado),
    (label: 'Rejeitado', status: CandidaturaStatus.rejeitado),
  ];

  int _filtroSelecionado = 0;

  List<CandidaturaMock> get _candidaturasFiltradas {
    final status = _filtros[_filtroSelecionado].status;
    if (status == null) return mockCandidaturas;
    return mockCandidaturas
        .where((candidatura) => candidatura.status == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final candidaturas = _candidaturasFiltradas;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              userName: 'Mariana Costa',
              hasUnreadNotifications: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text(
                    'Minhas candidaturas',
                    style: AppTextStyles.displayTitle,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Acompanhe o status das suas candidaturas.',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.neutral600,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _buildFiltros(),
                  const SizedBox(height: 18),
                  for (var index = 0; index < candidaturas.length; index++)
                    StaggeredListItem(
                      key: ValueKey(
                        '${_filtroSelecionado}_${candidaturas[index].titulo}',
                      ),
                      index: index,
                      child: _CardCandidatura(
                        candidatura: candidaturas[index],
                        corDestaque:
                            AppColors.cardAccentColors[mockCandidaturas.indexOf(
                                  candidaturas[index],
                                ) %
                                AppColors.cardAccentColors.length],
                      ),
                    ),
                  if (candidaturas.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        'Nenhuma candidatura encontrada.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onItemSelected: widget.onNavigationItemSelected ?? (_) {},
      ),
    );
  }

  Widget _buildFiltros() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < _filtros.length; index++) ...[
            if (index > 0) const SizedBox(width: 8),
            _FiltroChip(
              label: _filtros[index].label,
              selecionado: _filtroSelecionado == index,
              onTap: () => setState(() => _filtroSelecionado = index),
            ),
          ],
        ],
      ),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  const _FiltroChip({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selecionado,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selecionado ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selecionado ? AppColors.primary : AppColors.neutral200,
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.caption.copyWith(
              color: selecionado ? AppColors.white : AppColors.neutral600,
              fontWeight: FontWeight.w600,
            ),
            child: Text(label, maxLines: 1),
          ),
        ),
      ),
    );
  }
}

class _CardCandidatura extends StatefulWidget {
  const _CardCandidatura({
    required this.candidatura,
    required this.corDestaque,
  });

  final CandidaturaMock candidatura;
  final Color corDestaque;

  @override
  State<_CardCandidatura> createState() => _CardCandidaturaState();
}

class _CardCandidaturaState extends State<_CardCandidatura> {
  bool _pressionado = false;

  CandidaturaMock get candidatura => widget.candidatura;

  void _definirPressionado(bool valor) {
    if (_pressionado == valor) return;
    setState(() => _pressionado = valor);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${candidatura.titulo}, ${candidatura.empresa}',
      child: GestureDetector(
        onTapDown: (_) => _definirPressionado(true),
        onTapUp: (_) => _definirPressionado(false),
        onTapCancel: () => _definirPressionado(false),
        onTap: () {
          // TODO: navegar para os detalhes desta candidatura.
        },
        child: AnimatedScale(
          scale: _pressionado ? 0.985 : 1,
          duration: const Duration(milliseconds: 120),
          child: AppCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconAvatarBox(
                      icon: candidatura.icone,
                      color: widget.corDestaque,
                      size: 52,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    candidatura.titulo,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.cardTitle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              StatusBadge(
                                text: _textoStatus(candidatura.status),
                                type: _tipoStatus(candidatura.status),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            candidatura.empresa,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.cardSubtitle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _InfoCandidatura(
                      icone: Icons.location_on_outlined,
                      texto: candidatura.local,
                    ),
                    _InfoCandidatura(
                      icone: _iconeModalidade(candidatura.modalidade),
                      texto: candidatura.modalidade,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ProgressoCandidatura(candidatura: candidatura),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _textoStatus(CandidaturaStatus status) => switch (status) {
    CandidaturaStatus.emAnalise => 'Em análise',
    CandidaturaStatus.selecionado => 'Selecionado',
    CandidaturaStatus.rejeitado => 'Rejeitado',
  };

  StatusBadgeType _tipoStatus(CandidaturaStatus status) => switch (status) {
    CandidaturaStatus.emAnalise => StatusBadgeType.info,
    CandidaturaStatus.selecionado => StatusBadgeType.success,
    CandidaturaStatus.rejeitado => StatusBadgeType.danger,
  };

  IconData _iconeModalidade(String modalidade) => switch (modalidade) {
    'Remoto' => Icons.home_outlined,
    'Híbrido' => Icons.swap_horiz_rounded,
    _ => Icons.business_outlined,
  };
}

class _InfoCandidatura extends StatelessWidget {
  const _InfoCandidatura({required this.icone, required this.texto});

  final IconData icone;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, size: 15, color: AppColors.neutral600),
        const SizedBox(width: 4),
        Text(texto, style: AppTextStyles.caption),
      ],
    );
  }
}

class _ProgressoCandidatura extends StatelessWidget {
  const _ProgressoCandidatura({required this.candidatura});

  final CandidaturaMock candidatura;

  Color get _corProgresso => switch (candidatura.status) {
    CandidaturaStatus.emAnalise => AppColors.primary,
    CandidaturaStatus.selecionado => AppColors.success,
    CandidaturaStatus.rejeitado => AppColors.neutral400,
  };

  bool get _rejeitado => candidatura.status == CandidaturaStatus.rejeitado;
  bool get _selecionado => candidatura.status == CandidaturaStatus.selecionado;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (var index = 0; index < candidatura.etapas.length; index++) ...[
              if (index > 0)
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(height: 2, color: AppColors.neutral200),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: 2,
                        width: _selecionado || index <= candidatura.etapaAtual
                            ? double.infinity
                            : 0,
                        color: _corProgresso,
                      ),
                    ],
                  ),
                ),
              _PontoProgresso(
                ativo: _selecionado || index <= candidatura.etapaAtual,
                cor: _rejeitado ? AppColors.neutral400 : _corProgresso,
              ),
            ],
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            for (var index = 0; index < candidatura.etapas.length; index++)
              Expanded(
                child: Text(
                  candidatura.etapas[index],
                  textAlign: index == 0
                      ? TextAlign.left
                      : index == candidatura.etapas.length - 1
                      ? TextAlign.right
                      : TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color:
                        !_rejeitado &&
                            (_selecionado || index <= candidatura.etapaAtual)
                        ? _corProgresso
                        : AppColors.neutral600,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _PontoProgresso extends StatelessWidget {
  const _PontoProgresso({required this.ativo, required this.cor});

  final bool ativo;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: ativo ? cor : AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: ativo ? cor : AppColors.neutral200, width: 2),
      ),
    );
  }
}

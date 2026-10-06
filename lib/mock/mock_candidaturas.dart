import 'package:flutter/material.dart';

enum CandidaturaStatus { emAnalise, selecionado, rejeitado }

/// Modelo e exemplos locais usados pela tela de candidaturas.
class CandidaturaMock {
  const CandidaturaMock({
    required this.titulo,
    required this.empresa,
    required this.local,
    required this.modalidade,
    required this.status,
    required this.etapas,
    required this.etapaAtual,
    required this.icone,
  });

  final String titulo;
  final String empresa;
  final String local;
  final String modalidade;
  final CandidaturaStatus status;
  final List<String> etapas;
  final int etapaAtual;
  final IconData icone;
}

const mockCandidaturas = <CandidaturaMock>[
  CandidaturaMock(
    titulo: 'Desenvolvedor .NET',
    empresa: 'XP Tecnologia',
    local: 'Sorocaba, SP',
    modalidade: 'Híbrido',
    status: CandidaturaStatus.emAnalise,
    etapas: ['Candidatura', 'Entrevista', 'Resultado'],
    etapaAtual: 0,
    icone: Icons.code_rounded,
  ),
  CandidaturaMock(
    titulo: 'Analista de Sistemas',
    empresa: 'TechSolutions',
    local: 'São Paulo, SP',
    modalidade: 'Remoto',
    status: CandidaturaStatus.selecionado,
    etapas: ['Candidatura', 'Entrevista', 'Proposta'],
    etapaAtual: 2,
    icone: Icons.bar_chart_rounded,
  ),
  CandidaturaMock(
    titulo: 'Estágio em TI',
    empresa: 'Next Tecnologia',
    local: 'Campinas, SP',
    modalidade: 'Presencial',
    status: CandidaturaStatus.emAnalise,
    etapas: ['Candidatura', 'Entrevista', 'Resultado'],
    etapaAtual: 0,
    icone: Icons.laptop_mac_rounded,
  ),
  CandidaturaMock(
    titulo: 'Técnico de Suporte',
    empresa: 'HelpTech',
    local: 'Sorocaba, SP',
    modalidade: 'Presencial',
    status: CandidaturaStatus.rejeitado,
    etapas: ['Candidatura', 'Entrevista', 'Resultado'],
    etapaAtual: 0,
    icone: Icons.support_agent_rounded,
  ),
];

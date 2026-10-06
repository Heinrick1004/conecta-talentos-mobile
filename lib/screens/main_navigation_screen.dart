import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'candidaturas_screen.dart';
import 'capacitacao_screen.dart';
import 'home_screen.dart';
import 'perfil_screen.dart';

/// Mantém as quatro abas montadas e conserva o estado de cada tela.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selecionarAba(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SharedAxisTransition(
      animation: _animation,
      secondaryAnimation: ReverseAnimation(_animation),
      transitionType: SharedAxisTransitionType.horizontal,
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onNavigationItemSelected: _selecionarAba),
          CandidaturasScreen(onNavigationItemSelected: _selecionarAba),
          CapacitacaoScreen(onNavigationItemSelected: _selecionarAba),
          PerfilScreen(onNavigationItemSelected: _selecionarAba),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conecta_talentos_app/main.dart';
import 'package:conecta_talentos_app/mock/mock_favoritos.dart';
import 'package:conecta_talentos_app/mock/mock_vagas.dart';
import 'package:conecta_talentos_app/screens/cadastro_screen.dart';
import 'package:conecta_talentos_app/screens/login_screen.dart';
import 'package:conecta_talentos_app/screens/meus_interesses_screen.dart';
import 'package:conecta_talentos_app/theme/app_colors.dart';
import 'package:conecta_talentos_app/theme/app_theme.dart';

void main() {
  test(
    'favoritos impedem duplicação e permitem remover e adicionar novamente',
    () {
      final vaga = mockVagas.first;

      if (mockFavoritos.contem(vaga)) {
        mockFavoritos.alternar(vaga);
      }

      mockFavoritos.adicionar(vaga);
      mockFavoritos.adicionar(vaga);
      expect(mockFavoritos.vagas, hasLength(1));
      expect(mockFavoritos.contem(vaga), isTrue);

      mockFavoritos.remover(vaga);
      expect(mockFavoritos.vagas, isEmpty);
      mockFavoritos.adicionar(vaga);
      expect(mockFavoritos.vagas, hasLength(1));
      mockFavoritos.remover(vaga);
      expect(mockFavoritos.vagas, isEmpty);
    },
  );

  testWidgets('aplicativo inicia em LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 350));

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'ConectaTalentos');
    expect(app.theme!.colorScheme.primary, AppColors.primary);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
  });

  testWidgets('login vazio permanece no Login', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
    await tester.pump();

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(
      find.text('Informe seu e-mail e senha para continuar.'),
      findsOneWidget,
    );
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
  });

  testWidgets('login preenchido entra na Home', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField).at(0), 'teste@teste.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Olá, Guilherme 👋'), findsOneWidget);
    expect(find.text('Vagas para você'), findsOneWidget);
  });

  testWidgets('criar conta abre cadastro e retorna ao login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    );
    await tester.pump();

    await tester.tap(find.text('Criar conta'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(CadastroScreen), findsOneWidget);
    expect(find.text('Crie sua conta'), findsOneWidget);

    final voltar = find.text('Voltar para o login');
    await tester.ensureVisible(voltar);
    await tester.pump();
    await tester.tap(voltar);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('logout pode ser cancelado e limpa a pilha ao sair', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 700));
    await tester.enterText(find.byType(TextField).at(0), 'teste@teste.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    await tester.tap(find.text('Perfil'));
    await tester.pump();
    final botaoSair = find.text('Sair da conta');
    await tester.ensureVisible(botaoSair);
    await tester.pump();
    await tester.tap(botaoSair);
    await tester.pump();

    expect(find.text('Sair da conta?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    expect(find.text('Sair da conta'), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);

    await tester.ensureVisible(botaoSair);
    await tester.pump();
    await tester.tap(botaoSair);
    await tester.pump();
    await tester.tap(find.text('Sair'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Vagas para você'), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Vagas para você'), findsNothing);
  });

  testWidgets('favoritos abrem em Meus interesses e atualizam ao remover', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final vaga = mockVagas.first;
    if (mockFavoritos.contem(vaga)) {
      mockFavoritos.alternar(vaga);
    }

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 700));
    await tester.enterText(find.byType(TextField).at(0), 'teste@teste.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    final abrirDetalhes = find.byTooltip('Ver vaga: Desenvolvedor .NET');
    await tester.ensureVisible(abrirDetalhes);
    await tester.pump();
    await tester.tap(abrirDetalhes);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    await tester.tap(find.byTooltip('Adicionar aos interesses'));
    await tester.pump();
    expect(mockFavoritos.vagas, hasLength(1));
    expect(find.text('Vaga adicionada aos interesses'), findsOneWidget);

    await tester.tap(find.byTooltip('Remover dos interesses'));
    await tester.pump();
    expect(mockFavoritos.vagas, isEmpty);
    await tester.tap(find.byTooltip('Adicionar aos interesses'));
    await tester.pump();
    expect(mockFavoritos.vagas, hasLength(1));

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.tap(find.text('Perfil'));
    await tester.pump();

    final meusInteresses = find.text('Meus interesses');
    await tester.ensureVisible(meusInteresses);
    await tester.pump();
    await tester.tap(meusInteresses);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(MeusInteressesScreen), findsOneWidget);
    expect(find.text('Vagas que você salvou'), findsOneWidget);
    expect(find.text('Desenvolvedor .NET'), findsOneWidget);

    await tester.tap(find.text('Desenvolvedor .NET').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.tap(find.byTooltip('Remover dos interesses'));
    await tester.pump();

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(MeusInteressesScreen), findsOneWidget);
    expect(find.text('Nenhuma vaga salva ainda'), findsOneWidget);
    expect(find.text('Desenvolvedor .NET'), findsNothing);
  });
}

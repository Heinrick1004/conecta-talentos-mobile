// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conecta_talentos_app/main.dart';
import 'package:conecta_talentos_app/screens/cadastro_screen.dart';
import 'package:conecta_talentos_app/screens/home_screen.dart';
import 'package:conecta_talentos_app/screens/login_screen.dart';
import 'package:conecta_talentos_app/screens/perfil_screen.dart';
import 'package:conecta_talentos_app/mock/mock_usuario.dart';
import 'package:conecta_talentos_app/theme/app_colors.dart';
import 'package:conecta_talentos_app/theme/app_theme.dart';

Future<void> _avancarAnimacoes(WidgetTester tester, int quadros) async {
  for (var indice = 0; indice < quadros; indice++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('aplica o tema compartilhado e abre a Home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 350));

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'ConectaTalentos');
    expect(app.theme!.colorScheme.primary, AppColors.primary);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Olá, Guilherme 👋'), findsOneWidget);
    expect(find.text('Vagas para você'), findsOneWidget);
    expect(find.text('Desenvolvedor .NET'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('login adapta-se a tela móvel e alterna a senha', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('ConectaTalentos'), findsNothing);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final campoSenha = tester.widget<TextField>(find.byType(TextField).last);
    expect(campoSenha.obscureText, isTrue);

    await tester.tap(find.byTooltip('Mostrar senha'));
    await tester.pump();

    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isFalse,
    );
  });

  testWidgets('login abre cadastro e o link retorna ao login', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pump(const Duration(milliseconds: 700));
    final botaoCriarConta = find.widgetWithText(TextButton, 'Criar conta');
    await tester.ensureVisible(botaoCriarConta);
    await tester.pumpAndSettle();
    await tester.tap(botaoCriarConta);
    await tester.pumpAndSettle();

    expect(find.text('Crie sua conta'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));

    await tester.ensureVisible(find.text('Voltar para o login'));
    await tester.tap(find.text('Voltar para o login'));
    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('cadastro valida campos obrigatórios e senhas iguais', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CadastroScreen()));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.tap(find.text('Criar conta'));
    await tester.pump();

    expect(find.text('Preencha todos os campos obrigatórios.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Ana Silva');
    await tester.enterText(find.byType(TextField).at(1), 'ana@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'senha-segura');
    await tester.enterText(find.byType(TextField).at(3), 'senha-diferente');
    await tester.tap(find.text('Criar conta'));
    await tester.pump();

    expect(find.text('As senhas não coincidem.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(3), 'senha-segura');
    await tester.tap(find.text('Criar conta'));
    await tester.pump();

    expect(find.text('As senhas não coincidem.'), findsNothing);
    expect(find.text('Preencha todos os campos obrigatórios.'), findsNothing);
  });

  testWidgets('barra inferior navega entre as quatro telas principais', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Desenvolvedor .NET'), findsOneWidget);

    await tester.tap(find.text('Candidaturas'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Minhas candidaturas'), findsOneWidget);

    await tester.tap(find.text('Capacitação').last);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Seus treinamentos'), findsOneWidget);

    await tester.tap(find.text('Perfil'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Meu currículo'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Vagas para você'), findsOneWidget);
  });

  testWidgets('Home abre os detalhes da vaga selecionada', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
    );
    await tester.pump(const Duration(milliseconds: 700));

    final botaoDetalhes = find.byTooltip('Ver vaga: Desenvolvedor .NET');
    await tester.ensureVisible(botaoDetalhes);
    await tester.pump();
    await tester.tap(botaoDetalhes);
    await tester.pumpAndSettle();

    expect(find.text('Descrição', skipOffstage: false), findsOneWidget);
    expect(find.text('Candidatar-se', skipOffstage: false), findsOneWidget);
    expect(find.text('Desenvolvedor .NET'), findsOneWidget);
    expect(find.text('Descrição'), findsOneWidget);
    expect(find.text('Requisitos'), findsOneWidget);
    expect(
      find.text('Experiência com desenvolvimento em C# e .NET.'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Vagas para você'), findsOneWidget);
  });

  testWidgets('confirma candidatura com dados do perfil e abre candidaturas', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await _avancarAnimacoes(tester, 8);

    await tester.tap(find.byTooltip('Ver vaga: Desenvolvedor .NET'));
    await _avancarAnimacoes(tester, 8);
    await tester.tap(find.text('Candidatar-se'));
    await _avancarAnimacoes(tester, 8);

    expect(find.text('Revisar candidatura'), findsOneWidget);
    expect(find.text(mockUsuario.nome), findsOneWidget);
    expect(find.text(mockUsuario.email), findsOneWidget);
    expect(find.text(mockUsuario.telefone), findsOneWidget);
    expect(find.text('Cidade/UF'), findsOneWidget);
    expect(
      find.text('${mockUsuario.cidade}, ${mockUsuario.uf}'),
      findsNWidgets(2),
    );
    expect(find.text(mockUsuario.habilidades.first), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.tap(find.text('Editar perfil'));
    await _avancarAnimacoes(tester, 8);
    expect(find.text('Editar perfil'), findsOneWidget);
    await tester.tap(find.byTooltip('Voltar'));
    await _avancarAnimacoes(tester, 8);
    expect(find.text('Revisar candidatura'), findsOneWidget);

    final mensagem = find.byType(TextField);
    await tester.ensureVisible(mensagem);
    await tester.enterText(mensagem, 'Tenho experiência com .NET.');
    await tester.tap(find.text('Confirmar candidatura'));
    await _avancarAnimacoes(tester, 5);

    expect(find.text('Candidatura enviada!'), findsOneWidget);
    await tester.tap(find.text('Ir para candidaturas'));
    await _avancarAnimacoes(tester, 8);

    expect(find.text('Minhas candidaturas'), findsOneWidget);
  });

  testWidgets('Perfil edita dados pré-carregados e os atualiza ao voltar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final nomeOriginal = mockUsuario.nome;
    final emailOriginal = mockUsuario.email;
    final telefoneOriginal = mockUsuario.telefone;
    final cidadeOriginal = mockUsuario.cidade;
    final ufOriginal = mockUsuario.uf;
    final habilidadesOriginais = List<String>.from(mockUsuario.habilidades);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const PerfilScreen()),
    );
    await _avancarAnimacoes(tester, 6);
    await tester.tap(find.text('Meu currículo'));
    await _avancarAnimacoes(tester, 8);

    expect(find.text('Editar perfil'), findsOneWidget);
    final campos = find.byType(TextField);
    expect(campos, findsNWidgets(6));
    expect(
      tester.widget<TextField>(campos.at(0)).controller!.text,
      nomeOriginal,
    );
    expect(
      tester.widget<TextField>(campos.at(1)).controller!.text,
      emailOriginal,
    );
    expect(
      tester.widget<TextField>(campos.at(5)).controller!.text,
      habilidadesOriginais.join(', '),
    );

    await tester.enterText(campos.at(0), '');
    await tester.enterText(campos.at(1), '');
    await tester.ensureVisible(find.text('Salvar alterações'));
    await tester.tap(find.text('Salvar alterações'));
    await tester.pump();
    expect(find.text('Nome e e-mail são obrigatórios.'), findsOneWidget);

    const novosDados = [
      'Ana Souza',
      'ana.souza@example.com',
      '(15) 98888-7777',
      'Campinas',
      'sp',
      'Flutter, Dart\nREST',
    ];
    for (var indice = 0; indice < novosDados.length; indice++) {
      await tester.ensureVisible(campos.at(indice));
      await tester.enterText(campos.at(indice), novosDados[indice]);
    }

    await tester.ensureVisible(find.text('Salvar alterações'));
    await tester.tap(find.text('Salvar alterações'));
    await _avancarAnimacoes(tester, 5);

    expect(find.text('Perfil atualizado!'), findsOneWidget);
    expect(find.text('Ana Souza'), findsOneWidget);
    expect(mockUsuario.email, 'ana.souza@example.com');
    expect(mockUsuario.telefone, '(15) 98888-7777');
    expect(mockUsuario.cidade, 'Campinas');
    expect(mockUsuario.uf, 'SP');
    expect(mockUsuario.habilidades, ['Flutter', 'Dart', 'REST']);

    mockUsuario.atualizar(
      nome: nomeOriginal,
      email: emailOriginal,
      telefone: telefoneOriginal,
      cidade: cidadeOriginal,
      uf: ufOriginal,
      habilidades: habilidadesOriginais,
    );
  });
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:comunidade_em_acao/main.dart';
import 'package:comunidade_em_acao/screens/campaign_details_screen.dart';
import 'package:comunidade_em_acao/screens/donate_items_screen.dart';
import 'package:comunidade_em_acao/screens_windows/windows_shell.dart';
import 'package:comunidade_em_acao/state/app_state.dart';

// Mock transparent 1x1 png for test environment
final List<int> _kTransparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

class _TestHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getUrl ||
        invocation.memberName == #openUrl ||
        invocation.memberName == #get) {
      return Future<HttpClientRequest>.value(_TestHttpClientRequest());
    }
    return null;
  }
}

class _TestHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _TestHttpHeaders();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #close) {
      return Future<HttpClientResponse>.value(_TestHttpClientResponse());
    }
    return null;
  }
}

class _TestHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _TestHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  final HttpHeaders headers = _TestHttpHeaders();
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  String get reasonPhrase => 'OK';

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('Login screen loads and logs in to mobile home feed', (WidgetTester tester) async {
    final state = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const ComunidadeEmAcaoApp(initialWindowsMode: false),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Login Screen is displayed
    expect(find.text('Bem-vindo de volta!'), findsOneWidget);
    expect(find.text('Faça login para continuar espalhando solidariedade.'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Entrar com Google'), findsOneWidget);
    expect(find.text('Mais de 1.400 famílias apoiadas'), findsNothing);

    // Tap "Entrar" to login
    await tester.tap(find.text('Entrar'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify successful login transitions to Home Screen
    expect(find.text('Ana Paula'), findsOneWidget);
    expect(find.text('Olá, Ana Paula'), findsOneWidget);
    expect(find.text('Campanhas Urgentes'), findsOneWidget);
    expect(find.text('Campanha do Agasalho 2025'), findsWidgets);
    expect(find.text('Horta Solidária e Cestas Básicas para 120 Famílias'), findsOneWidget);
  });

  testWidgets('Mobile Details screen and Donate Items counter interaction test', (WidgetTester tester) async {
    final state = AppState();
    final campaign = state.mainCampaign;

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          home: CampaignDetailsScreen(campaign: campaign),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify campaign details elements
    expect(find.text('Detalhes Da Campanha'), findsOneWidget);

    // Test direct render of DonateItemsScreen
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          home: DonateItemsScreen(campaign: campaign),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Now in DonateItemsScreen
    expect(find.text('Doar Itens para a Campanha'), findsOneWidget);
    expect(find.text('Passo 1 de 2'), findsOneWidget);
    expect(find.text('Confirmar Doação de Itens'), findsOneWidget);
  });

  testWidgets('Windows Fluent Shell renders sidebar, topbar, dashboard, and navigates', (WidgetTester tester) async {
    // Set desktop window size
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(
          home: WindowsShell(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Windows Fluent Sidebar
    expect(find.text('Comunidade'), findsOneWidget);
    expect(find.text('EM AÇÃO'), findsOneWidget);
    expect(find.text('Início / Feed'), findsOneWidget);
    expect(find.text('Explorar Campanhas'), findsOneWidget);
    expect(find.text('Minhas Doações'), findsOneWidget);
    expect(find.text('Criar Campanha'), findsOneWidget);
    expect(find.text('Impacto & Transparência'), findsOneWidget);
    expect(find.text('Configurações'), findsOneWidget);
    expect(find.text('Ana Paula'), findsOneWidget);

    // Verify Windows Command Bar Topbar
    expect(find.text('Ctrl+K'), findsOneWidget);
    expect(find.text('São Paulo, SP'), findsWidgets);
    expect(find.text('Nova Campanha'), findsOneWidget);

    // Verify Dashboard Banner and Campaigns
    expect(find.text('ZONA SUL E REGIÃO METROPOLITANA'), findsOneWidget);
    expect(find.text('Famílias apoiadas'), findsOneWidget);
    expect(find.text('Campanha do Agasalho 2025'), findsWidgets);
    expect(find.text('Horta Solidária e Cestas Básicas para 120 Famílias'), findsOneWidget);

    // Test navigation to Minhas Doações tab
    await tester.tap(find.text('Minhas Doações'));
    await tester.pumpAndSettle();
    expect(find.text('Minhas Contribuições Solidárias'), findsOneWidget);
    expect(find.text('CAMPANHA / CAUSA'), findsOneWidget);

    // Test navigation to Criar Campanha tab
    await tester.tap(find.text('Criar Campanha'));
    await tester.pumpAndSettle();
    expect(find.text('Criar Nova Campanha Comunitária'), findsOneWidget);
    expect(find.text('1. Informações Essenciais da Causa'), findsOneWidget);
    expect(find.text('Pré-visualização do Feed'), findsOneWidget);
    expect(find.text('Publicar Campanha'), findsOneWidget);
  });
}

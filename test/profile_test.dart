import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:comunidade_em_acao/screens/profile_screen.dart';
import 'package:comunidade_em_acao/state/app_state.dart';

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

class _TestHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
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
    void Function(List<int> data)? onData, {
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

  testWidgets('Perfil mostra nivel real, conquistas e salva edicao', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(420, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Estado real do usuário demo: 42 itens doados -> Nível 3.
    expect(find.text('Meu Perfil'), findsOneWidget);
    expect(find.text('Nível 3 • Colaborador'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('Conquistas'), findsOneWidget);
    expect(find.text('Primeira Doação'), findsOneWidget);
    expect(find.text('Última doação'), findsOneWidget);

    // Edição do nome reflete no cabeçalho e no estado.
    await tester.ensureVisible(find.text('Editar Dados Pessoais'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar Dados Pessoais'));
    await tester.pumpAndSettle();
    expect(find.text('Editar Perfil'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Ana Paula Souza');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(state.user.name, 'Ana Paula Souza');
    expect(find.text('Ana Paula Souza'), findsOneWidget);

    // Aba de recibos lista as doações confirmadas.
    await tester.ensureVisible(find.text('Histórico de Recibos'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Histórico de Recibos'));
    await tester.pumpAndSettle();
    expect(find.textContaining('CMP-'), findsWidgets);
  });
}

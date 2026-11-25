import 'package:flutter_test/flutter_test.dart';
import 'package:comunidade_em_acao/state/app_state.dart';

void main() {
  test('login com Google falha de forma amigavel sem Firebase ativo', () async {
    final state = AppState();

    final error = await state.loginWithGoogle();

    expect(error, isNotNull);
    expect(error!.toLowerCase(), contains('google'));
    expect(state.isAuthenticated, isFalse);
  });
}

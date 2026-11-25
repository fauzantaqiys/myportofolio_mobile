import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  testWidgets('Login dari drawer, simpan pengalaman, dan logout', (
    tester,
  ) async {
    var posts = 0;
    var logouts = 0;
    final api = ApiClient(
      client: MockClient((r) {
        switch (r.url.path) {
          case '/api/v1/auth/token/':
            final data = jsonDecode(r.body);
            return Future.value(
              data['password'] == 'test-only'
                  ? http.Response('{"token":"test-token"}', 200)
                  : http.Response('{}', 400),
            );
          case '/api/v1/experiences/':
            expect(r.headers['Authorization'], 'Token test-token');
            final data = jsonDecode(r.body);
            expect(data['category'], 'full-time');
            expect(data['ended_at'], isNull);
            posts++;
            return Future.value(
              http.Response(jsonEncode({...data, 'id': 'test-id'}), 201),
            );
          case '/api/v1/auth/logout/':
            expect(r.headers['Authorization'], 'Token test-token');
            logouts++;
            return Future.value(http.Response('', 204));
          default:
            throw StateError(r.url.path);
        }
      }),
    );
    addTearDown(api.close);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: api),
          ChangeNotifierProvider(create: (_) => AuthState(api)),
        ],
        child: MaterialApp(home: MyHomePage()),
      ),
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'owner');
    await tester.enterText(find.byType(TextFormField).last, 'wrong');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Username atau password salah.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).last, 'test-only');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Add Experience Form'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'Riset');
    await tester.enterText(find.byType(TextFormField).at(1), 'Analisis');
    final start = find.byType(TextFormField).at(3);
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(posts, 1);
    expect(find.text('Pengalaman berhasil ditambahkan'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(logouts, 1);
    await tester.tap(find.text('Tambah Pengalaman'));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);
  });
}

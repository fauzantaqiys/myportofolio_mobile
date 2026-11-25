import 'dart:async';

import 'package:myportofolio_mobile/services/auth_state.dart';

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Daftar publik, coba lagi, refresh, dan detail', (tester) async {
    var response = Completer<http.Response>();
    final api = ApiClient(
      client: MockClient((request) {
        expect(request.url.path, '/api/v1/experiences/');
        return response.future;
      }),
    );
    addTearDown(api.close);
    await tester.pumpWidget(
      Provider.value(
        value: api,
        child: ChangeNotifierProvider(
          create: (_) => AuthState(api),
          child: MaterialApp(home: MyHomePage()),
        ),
      ),
    );
    await tester.tap(find.text('Lihat Pengalaman'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    response.complete(http.Response('', 503));
    await tester.pumpAndSettle();
    response = Completer();
    await tester.tap(find.text('Coba lagi'));
    response.complete(http.Response('[]', 200));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada pengalaman.'), findsOneWidget);
    response = Completer();
    await tester.drag(find.byType(ListView), const Offset(0, 400));
    await tester.pump(const Duration(milliseconds: 300));
    response.complete(
      http.Response(
        jsonEncode([
          {
            'title': 'Asisten riset',
            'category': 'research',
            'description': 'Analisis data',
            'started_at': '2026-01-20T00:00:00Z',
          },
        ]),
        200,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Asisten riset'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Pengalaman'), findsOneWidget);
    expect(find.textContaining('Sekarang'), findsOneWidget);
    expect(find.text('Analisis data'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Daftar Pengalaman'), findsOneWidget);
  });
}

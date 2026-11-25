import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../services/auth_state.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  return await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      ) ??
      false;
}

Future<void> handleSessionAction(BuildContext context) async {
  final auth = context.read<AuthState>();
  if (!auth.isLoggedIn) {
    await ensureLoggedIn(context);
    return;
  }
  final messenger = ScaffoldMessenger.of(context);
  var message = 'Kamu sudah logout.';
  try {
    await auth.logout();
  } on Exception {
    message =
        'Sesi di aplikasi sudah berakhir. Logout di server gagal dikonfirmasi.';
  }
  if (messenger.mounted) {
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

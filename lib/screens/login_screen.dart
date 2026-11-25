import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../services/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  String _username = '', _password = '';
  bool _busy = false;
  String? _error;

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await context.read<AuthState>().login(_username.trim(), _password);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(
          () => _error = e.statusCode == 400 || e.statusCode == 401
              ? 'Username atau password salah.'
              : e.toString(),
        );
      }
    } on Exception {
      if (mounted) setState(() => _error = 'Login gagal. Coba lagi.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Username'),
            onChanged: (v) => _username = v,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Isi username.' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (v) => _password = v,
            validator: (v) => v == null || v.isEmpty ? 'Isi password.' : null,
            onFieldSubmitted: (_) => _submit(),
          ),
          if (_error != null) Text(_error!),
          ElevatedButton(
            onPressed: _busy ? null : _submit,
            child: const Text('Masuk'),
          ),
        ],
      ),
    ),
  );
}

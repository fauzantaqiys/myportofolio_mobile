import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import 'auth_guard.dart';

import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/experience_list.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Navigasi ke halaman utama portofolio
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Lihat Pengalaman'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.push(
                MaterialPageRoute<void>(
                  builder: (_) => const ExperienceListPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            // Navigasi ke halaman tambah proyek
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Add Experience'),
            onTap: () async {
              final navigator = Navigator.of(context);
              navigator.pop();
              if (await ensureLoggedIn(navigator.context) &&
                  navigator.mounted) {
                navigator.push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ExperienceFormPage(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(
              context.watch<AuthState>().isLoggedIn
                  ? Icons.logout
                  : Icons.login,
            ),
            title: Text(
              context.watch<AuthState>().isLoggedIn ? 'Logout' : 'Login',
            ),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              handleSessionAction(navigator.context);
            },
          ),
        ],
      ),
    );
  }
}

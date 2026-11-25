import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import 'auth_guard.dart';

import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/experience_list.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final sessionCard = item.name == 'Logout';
    final loggedIn = sessionCard && context.watch<AuthState>().isLoggedIn;
    return Material(
      // Menggunakan warna unik dari properti color milik ItemHomepage.
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Aksi ketika kartu ditekan oleh pengguna.
        onTap: () async {
          if (sessionCard) {
            await handleSessionAction(context);
            return;
          }
          if (item.name == 'Lihat Pengalaman') {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const ExperienceListPage(),
              ),
            );
            return;
          }
          if (item.name == 'Tambah Pengalaman') {
            if (await ensureLoggedIn(context) && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const ExperienceFormPage(),
                ),
              );
            }
            return;
          }
          // Menampilkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
              ),
            );

          // Navigate ke halaman yang sesuai
          if (item.name == "Tambah Proyek") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectFormPage()),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  sessionCard && !loggedIn ? Icons.login : item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  sessionCard && !loggedIn ? 'Login' : item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

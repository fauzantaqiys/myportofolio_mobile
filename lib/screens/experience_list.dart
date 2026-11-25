import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

class ExperienceListPage extends StatefulWidget {
  const ExperienceListPage({super.key});

  @override
  State<ExperienceListPage> createState() => _ExperienceListPageState();
}

class _ExperienceListPageState extends State<ExperienceListPage> {
  late Future<List<Experience>> _experiences;

  @override
  void initState() {
    super.initState();
    _experiences = context.read<ApiClient>().getExperiences();
  }

  Future<void> _reload() async {
    final request = context.read<ApiClient>().getExperiences();
    setState(() {
      _experiences = request;
    });
    // FutureBuilder displays request errors, including refresh failures.
    await request.then<void>((_) {}, onError: (Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pengalaman')),
      body: FutureBuilder<List<Experience>>(
        future: _experiences,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Daftar pengalaman gagal dimuat.'),
                  TextButton(
                    onPressed: _reload,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          final items = snapshot.requireData;
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.isEmpty ? 1 : items.length,
              itemBuilder: (context, index) {
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('Belum ada pengalaman.')),
                  );
                }
                final experience = items[index];
                return ListTile(
                  title: Text(experience.title),
                  subtitle: Text(
                    '${experience.category}\n${experience.description}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => ExperienceDetailPage(experience),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

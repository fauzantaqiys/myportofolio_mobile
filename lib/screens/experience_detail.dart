import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailPage extends StatelessWidget {
  const ExperienceDetailPage(this.experience, {super.key});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final dates = MaterialLocalizations.of(context);
    final start = dates.formatMediumDate(experience.startedAt.toLocal());
    final end = experience.endedAt;
    final thumbnail = experience.thumbnail;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengalaman')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (thumbnail != null && thumbnail.isNotEmpty)
            Image.network(
              thumbnail,
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          Text(
            experience.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(experience.category),
          Text(
            '$start – ${end == null ? "Sekarang" : dates.formatMediumDate(end.toLocal())}',
          ),
          const SizedBox(height: 16),
          Text(experience.description),
        ],
      ),
    );
  }
}

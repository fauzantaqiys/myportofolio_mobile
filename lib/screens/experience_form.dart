import '../models/experience.dart';
import '../services/api_client.dart';
import '../services/auth_state.dart';
import '../widgets/auth_guard.dart';

import 'package:provider/provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  bool _saving = false;
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";
  String _category = "Full-Time";
  String _thumbnail = "";
  DateTime? _startedAt;
  DateTime? _endedAt;

  final TextEditingController _startedAtController = TextEditingController();
  final TextEditingController _endedAtController = TextEditingController();

  final List<String> _categories = [
    'Full-Time',
    'Part-Time',
    'Internship',
    'Research',
    'Volunteer',
    'Freelance',
  ];

  @override
  void dispose() {
    _startedAtController.dispose();
    _endedAtController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startedAt ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (mounted && picked != null) {
      setState(() {
        _startedAt = picked;
        _startedAtController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? (_startedAt ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (mounted && picked != null) {
      setState(() {
        _endedAt = picked;
        _endedAtController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    String? usedToken;
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      usedToken = auth.token;
      if (usedToken == null) return;
      final result = await api.createExperience(
        Experience(
          title: _title.trim(),
          description: _description.trim(),
          category: _category.toLowerCase(),
          thumbnail: _thumbnail.trim().isEmpty ? null : _thumbnail.trim(),
          startedAt: _startedAt!,
          endedAt: _endedAt,
        ),
        token: usedToken,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Pengalaman berhasil ditambahkan'),
          content: Text(result.title),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401 && usedToken != null) {
        auth.expire(usedToken);
        _message('Sesi berakhir. Login kembali, lalu tekan Save.');
        await ensureLoggedIn(context);
      } else {
        _message(
          e.statusCode == 403
              ? 'Hanya pemilik portofolio yang dapat menambah pengalaman.'
              : e.toString(),
        );
      }
    } on Exception {
      if (mounted) {
        _message(
          'Penyimpanan belum terkonfirmasi. Periksa daftar pengalaman dan koneksimu.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Judul Pengalaman ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Software Engineer Intern di Google",
                    labelText: "Judul / Posisi Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Judul pengalaman tidak boleh kosong!";
                    }
                    if (value.trim().length > 255) {
                      return "Judul tidak boleh melebihi 255 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Deskripsi Pengalaman ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        "Jelaskan peran, tanggung jawab, dan pencapaian Anda",
                    labelText: "Deskripsi Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi pengalaman tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Kategori Pengalaman ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // === Thumbnail URL (Opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "https://example.com/logo.png",
                    labelText: "URL Thumbnail / Logo Perusahaan (opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final uri = Uri.tryParse(value.trim());
                      if (uri == null ||
                          !uri.hasScheme ||
                          !['http', 'https'].contains(uri.scheme)) {
                        return "Format URL tidak valid! Harus diawali http:// atau https://";
                      }
                    }
                    return null;
                  },
                ),
              ),

              // === Tanggal Mulai ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startedAtController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Tanggal Mulai",
                    hintText: "Pilih tanggal mulai",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onTap: () => _selectStartDate(context),
                  validator: (String? value) {
                    if (_startedAt == null ||
                        value == null ||
                        value.trim().isEmpty) {
                      return "Tanggal mulai wajib dipilih!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tanggal Selesai (Opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endedAtController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Tanggal Selesai (opsional)",
                    hintText: "Kosongkan jika masih berlangsung",
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_endedAt != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: "Hapus tanggal selesai",
                            onPressed: () {
                              setState(() {
                                _endedAt = null;
                                _endedAtController.clear();
                              });
                            },
                          ),
                        const Icon(Icons.event),
                        const SizedBox(width: 8),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onTap: () => _selectEndDate(context),
                  validator: (String? value) {
                    if (_startedAt != null && _endedAt != null) {
                      if (_endedAt!.isBefore(_startedAt!)) {
                        return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                      }
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _saving ? null : _submit,
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

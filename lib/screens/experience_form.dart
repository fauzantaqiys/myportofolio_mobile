import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
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
    if (picked != null) {
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
    if (picked != null) {
      setState(() {
        _endedAt = picked;
        _endedAtController.text = _formatDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Add Experience Form'),
        ),
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
                    hintText: "Jelaskan peran, tanggung jawab, dan pencapaian Anda",
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
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
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
                    if (_startedAt == null || value == null || value.trim().isEmpty) {
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
                      backgroundColor:
                          WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Pengalaman Berhasil Ditambahkan!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Judul / Posisi: $_title'),
                                    const SizedBox(height: 4),
                                    Text('Deskripsi: $_description'),
                                    const SizedBox(height: 4),
                                    Text('Kategori: $_category'),
                                    const SizedBox(height: 4),
                                    Text('Thumbnail: ${_thumbnail.trim().isNotEmpty ? _thumbnail.trim() : "-"}'),
                                    const SizedBox(height: 4),
                                    Text('Tanggal Mulai: ${_formatDate(_startedAt!)}'),
                                    const SizedBox(height: 4),
                                    Text('Tanggal Selesai: ${_endedAt != null ? _formatDate(_endedAt!) : "Masih Berlangsung (Ongoing)"}'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _startedAt = null;
                                      _endedAt = null;
                                      _startedAtController.clear();
                                      _endedAtController.clear();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
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

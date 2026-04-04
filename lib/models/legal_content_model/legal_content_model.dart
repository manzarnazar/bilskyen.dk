class LegalContentModel {
  final Map<String, String> sections;

  const LegalContentModel({
    required this.sections,
  });

  bool get isEmpty => sections.isEmpty;

  List<MapEntry<String, String>> get orderedSections => sections.entries.toList();

  factory LegalContentModel.fromJson(Map<String, dynamic> json) {
    final parsed = <String, String>{};

    for (final entry in json.entries) {
      final value = entry.value;
      if (value != null) {
        final text = value.toString().trim();
        if (text.isNotEmpty) {
          parsed[entry.key] = text;
        }
      }
    }

    return LegalContentModel(sections: parsed);
  }
}

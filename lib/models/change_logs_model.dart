class Changelog {
  final List<String> fixes;

  Changelog({required this.fixes});

  factory Changelog.fromJson(Map<String, dynamic> json) {
    return Changelog(fixes: List<String>.from(json['fixes'] ?? []));
  }
}

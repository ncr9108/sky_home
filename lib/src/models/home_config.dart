import 'home_section.dart';

class HomeConfig {
  final String shop;
  final bool isPublished;
  final DateTime? updatedAt;
  final List<HomeSection> sections;

  const HomeConfig({
    required this.shop,
    required this.isPublished,
    this.updatedAt,
    required this.sections,
  });

  factory HomeConfig.fromJson(Map<String, dynamic> json) {
    return HomeConfig(
      shop: json['shop'] as String,
      isPublished: json['isPublished'] as bool? ?? false,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map((s) => HomeSection.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

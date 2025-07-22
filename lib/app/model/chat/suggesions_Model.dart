class SuggesionsModel {
  bool success;
  List<String> suggestions;

  SuggesionsModel({
    required this.success,
    required this.suggestions,
  });

  factory SuggesionsModel.fromJson(Map<String, dynamic> json) {
    return SuggesionsModel(
      success: json['success'] ?? false,
      suggestions: List<String>.from(json['suggestions'] ?? []),
    );
  }
}
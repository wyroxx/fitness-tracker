class Exercise {
  final String name;
  final String description;

  const Exercise({
    required this.name,
    required this.description,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

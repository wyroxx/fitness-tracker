class Exercise {
  final int id;
  final String name;
  final String description;

  const Exercise({
    required this.name,
    required this.description,
    required this.id,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

class MuscleGroup {
  final int id;
  final String name;

  const MuscleGroup({required this.id, required this.name});

  factory MuscleGroup.fromJson(Map<String, dynamic> json) =>
      MuscleGroup(id: json['id'] as int, name: json['name'] as String);
}

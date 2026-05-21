class WorkoutSet {
  final int? reps;
  final int? weight;
  final int? distanceMeters;
  final int? durationSeconds;

  const WorkoutSet({
    required this.reps,
    required this.weight,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => WorkoutSet(
    reps: json['reps'] as int?,
    weight: json['weight_kg'] as int?,
    distanceMeters: json['distance_meters'] as int?,
    durationSeconds: json['duration_seconds'] as int?,
  );
}

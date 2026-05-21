import 'package:fitness_tracker/features/profile/data/models/stats.dart';
import 'package:fitness_tracker/features/profile/data/models/user.dart';

abstract interface class ProfileRepository {
  Future<User> getUser();
  Future<UserStats> getStats();
  Future<String> getSuggestion();
}

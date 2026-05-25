import 'package:fitness_tracker/features/profile/data/models/stats.dart';
import 'package:fitness_tracker/features/profile/data/models/user.dart';

class ProfileData {
  final User user;
  final UserStats stats;

  const ProfileData({required this.user, required this.stats});
}

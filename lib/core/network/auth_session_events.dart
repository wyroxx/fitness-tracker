import 'package:flutter_riverpod/flutter_riverpod.dart';

final authSessionEventsProvider = NotifierProvider<AuthSessionEvents, int>(
  AuthSessionEvents.new,
);

class AuthSessionEvents extends Notifier<int> {
  @override
  int build() => 0;

  void expireSession() {
    state++;
  }
}

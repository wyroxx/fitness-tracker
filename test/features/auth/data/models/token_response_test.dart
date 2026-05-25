import 'package:fitness_tracker/features/auth/data/models/token_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses token response from json', () {
    final response = TokenResponse.fromJson({
      'access_token': 'access-token',
      'refresh_token': 'refresh-token',
    });

    expect(response.accessToken, 'access-token');
    expect(response.refreshToken, 'refresh-token');
  });
}

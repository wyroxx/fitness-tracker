class TokenResponse {
  const TokenResponse({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }
}

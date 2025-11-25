class AuthToken {
  const AuthToken({required this.token, required this.expiry});

  final String token;
  final DateTime expiry;

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
        token: json['token'] as String,
        expiry: DateTime.parse(json['expiresAt'] as String),
      );
}

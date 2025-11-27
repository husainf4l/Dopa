class UserProfile {
  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.dateOfBirth,
    this.phoneNumber,
    this.bloodType,
    this.address,
    this.profilePhotoUrl,
    this.weight,
    this.height,
  });

  final String id;
  final String email;
  final String fullName;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final String? bloodType;
  final String? address;
  final String? profilePhotoUrl;
  final double? weight;
  final double? height;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        email: json['email'] as String,
        fullName: json['fullName'] as String,
        dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
        phoneNumber: json['phoneNumber'] as String?,
        bloodType: json['bloodType'] as String?,
        address: json['address'] as String?,
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
        weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
        height: json['height'] != null ? (json['height'] as num).toDouble() : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'fullName': fullName,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'phoneNumber': phoneNumber,
        'bloodType': bloodType,
        'address': address,
        'profilePhotoUrl': profilePhotoUrl,
        'weight': weight,
        'height': height,
      };

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? bloodType,
    String? address,
    String? profilePhotoUrl,
    double? weight,
    double? height,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bloodType: bloodType ?? this.bloodType,
      address: address ?? this.address,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }
}

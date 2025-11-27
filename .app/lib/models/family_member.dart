import 'package:flutter/material.dart';

class FamilyMember {
  FamilyMember({
    required this.id,
    required this.fullName,
    required this.relationship,
    this.dateOfBirth,
    this.phoneNumber,
    this.bloodType,
    this.address,
    this.profilePhotoUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String fullName;
  final String relationship; // e.g., 'Parent', 'Child', 'Spouse', 'Sibling'
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final String? bloodType;
  final String? address;
  final String? profilePhotoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        relationship: json['relationship'] as String,
        dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
        phoneNumber: json['phoneNumber'] as String?,
        bloodType: json['bloodType'] as String?,
        address: json['address'] as String?,
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'relationship': relationship,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'phoneNumber': phoneNumber,
        'bloodType': bloodType,
        'address': address,
        'profilePhotoUrl': profilePhotoUrl,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  FamilyMember copyWith({
    String? id,
    String? fullName,
    String? relationship,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? bloodType,
    String? address,
    String? profilePhotoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      relationship: relationship ?? this.relationship,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bloodType: bloodType ?? this.bloodType,
      address: address ?? this.address,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to get relationship color
  Color getRelationshipColor() {
    switch (relationship.toLowerCase()) {
      case 'parent':
      case 'mother':
      case 'father':
        return const Color(0xFF6366F1); // Indigo
      case 'child':
      case 'son':
      case 'daughter':
        return const Color(0xFFF59E0B); // Amber
      case 'spouse':
      case 'husband':
      case 'wife':
        return const Color(0xFFEC4899); // Pink
      case 'sibling':
      case 'brother':
      case 'sister':
        return const Color(0xFF10B981); // Emerald
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Helper method to get relationship icon
  IconData getRelationshipIcon() {
    switch (relationship.toLowerCase()) {
      case 'parent':
      case 'mother':
      case 'father':
        return Icons.family_restroom_rounded;
      case 'child':
      case 'son':
      case 'daughter':
        return Icons.child_care_rounded;
      case 'spouse':
      case 'husband':
      case 'wife':
        return Icons.favorite_rounded;
      case 'sibling':
      case 'brother':
      case 'sister':
        return Icons.people_rounded;
      default:
        return Icons.person_rounded;
    }
  }
}
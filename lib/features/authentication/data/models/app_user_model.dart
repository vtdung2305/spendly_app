import 'package:spendly_app/features/authentication/domain/entities/app_user.dart';

/// DTO for the `public.profiles` Supabase row. Kept separate from [AppUser]
/// so JSON shape can change without touching domain/presentation.
class AppUserModel {
  const AppUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.address,
    this.avatarUrl,
  });

  /// Maps a `public.profiles` row (id, first_name, last_name, email, phone,
  /// address, avatar_url). Falls back to splitting `full_name` when
  /// first_name/last_name are null — covers rows written before the schema
  /// migration that added those columns.
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    final fullName = json['full_name'] as String? ?? '';
    final hasSpace = fullName.contains(RegExp(r'\s'));
    final fallbackFirst = hasSpace ? fullName.split(RegExp(r'\s+')).first : '';
    final fallbackLast =
        hasSpace ? fullName.split(RegExp(r'\s+')).skip(1).join(' ') : fullName;

    return AppUserModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String? ?? fallbackFirst,
      lastName: json['last_name'] as String? ?? fallbackLast,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Maps the backend's `GET/PATCH /users/me` response (camelCase,
  /// `firstName`/`lastName` always present).
  factory AppUserModel.fromBackendJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? address;
  final String? avatarUrl;

  /// `full_name` is included so it stays in sync for any code that still
  /// reads that column directly.
  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'full_name': [firstName, lastName]
            .where((part) => part.trim().isNotEmpty)
            .join(' '),
        'email': email,
        'phone': phone,
        'address': address,
        'avatar_url': avatarUrl,
      };

  AppUser toEntity() => AppUser(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        address: address,
        avatarUrl: avatarUrl,
      );
}

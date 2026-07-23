import '../../domain/entities/app_user.dart';

/// DTO for the `auth.users` / `profiles` Supabase row. Kept separate from
/// [AppUser] so JSON shape can change without touching domain/presentation.
class AppUserModel {
  const AppUserModel({required this.id, required this.name, required this.email});

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  final String id;
  final String name;
  final String email;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

  AppUser toEntity() => AppUser(id: id, name: name, email: email);
}

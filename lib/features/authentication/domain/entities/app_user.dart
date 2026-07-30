/// Pure domain entity for the signed-in user — no JSON/Supabase concerns.
///
/// [firstName] is "Họ" and [lastName] is "Tên" per the Edit Profile design
/// (screen 12b) — [name] concatenates them in that order to match how
/// Vietnamese full names are displayed elsewhere in the app.
class AppUser {
  const AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.address,
    this.avatarUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? address;
  final String? avatarUrl;

  String get name =>
      [firstName, lastName].where((part) => part.trim().isNotEmpty).join(' ');

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

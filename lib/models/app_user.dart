/// Minimal identity for the signed-in player, derived from the Clerk user.
class AppUser {
  final String id;
  final String email;
  final String name;

  const AppUser({required this.id, required this.email, required this.name});
}

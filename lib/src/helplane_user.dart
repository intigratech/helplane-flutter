/// Represents a user in the HelpLane chat system.
class HelpLaneUser {
  /// Unique identifier for the user.
  final String id;

  /// Display name of the user.
  final String? name;

  /// Email address of the user.
  final String? email;

  /// URL to the user's avatar image.
  final String? avatarUrl;

  /// Custom attributes for the user.
  final Map<String, dynamic>? customAttributes;

  /// Creates a new [HelpLaneUser].
  const HelpLaneUser({
    required this.id,
    this.name,
    this.email,
    this.avatarUrl,
    this.customAttributes,
  });

  /// Converts this user to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (customAttributes != null) 'customAttributes': customAttributes,
    };
  }
}

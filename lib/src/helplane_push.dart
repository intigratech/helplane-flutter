import 'helplane.dart';

/// Handles push notification integration for HelpLane.
///
/// HelpLane uses OneSignal for push notifications. This class provides
/// helper methods for integrating with OneSignal in your Flutter app.
class HelpLanePush {
  HelpLanePush._();

  /// Registers the current user for push notifications.
  ///
  /// Call this after identifying the user with [HelpLane.identify]
  /// and after initializing OneSignal.
  ///
  /// This sets the OneSignal external user ID to match the HelpLane
  /// contact ID format: `contact_{userId}`.
  ///
  /// Example with OneSignal:
  /// ```dart
  /// // After OneSignal initialization
  /// HelpLanePush.register();
  /// ```
  static void register() {
    final user = HelpLane.currentUser;
    if (user == null) {
      throw StateError(
        'No user identified. Call HelpLane.identify() before registering for push notifications.',
      );
    }

    // The external ID should be set on your OneSignal instance
    // OneSignal.login('contact_${user.id}');
    //
    // This method is a reminder/helper - actual OneSignal integration
    // should be done in your app code since OneSignal SDK setup varies.
  }

  /// Returns the external user ID format used by HelpLane.
  ///
  /// Use this when setting up OneSignal:
  /// ```dart
  /// OneSignal.login(HelpLanePush.getExternalUserId());
  /// ```
  static String? getExternalUserId() {
    final user = HelpLane.currentUser;
    if (user == null) return null;
    return 'contact_${user.id}';
  }

  /// Checks if a notification payload is from HelpLane.
  ///
  /// Use this in your notification handler to determine if the
  /// notification should open the HelpLane chat.
  ///
  /// Example:
  /// ```dart
  /// OneSignal.Notifications.addClickListener((event) {
  ///   if (HelpLanePush.isHelpLaneNotification(event.notification.additionalData)) {
  ///     HelpLane.openChat(context);
  ///   }
  /// });
  /// ```
  static bool isHelpLaneNotification(Map<String, dynamic>? data) {
    if (data == null) return false;
    return data['source'] == 'helplane' ||
        data.containsKey('helplane_conversation_id');
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';

import 'helplane_user.dart';
import 'helplane_chat.dart';

/// Main class for configuring and interacting with HelpLane.
class HelpLane {
  static HelpLane? _instance;

  /// The brand token for authentication.
  final String brandToken;

  /// The base URL for the HelpLane instance.
  final String baseUrl;

  /// The currently identified user.
  HelpLaneUser? _currentUser;

  HelpLane._({
    required this.brandToken,
    required this.baseUrl,
  });

  /// Returns the singleton instance of HelpLane.
  ///
  /// Throws [StateError] if [configure] hasn't been called.
  static HelpLane get instance {
    if (_instance == null) {
      throw StateError(
        'HelpLane has not been configured. Call HelpLane.configure() first.',
      );
    }
    return _instance!;
  }

  /// Returns whether HelpLane has been configured.
  static bool get isConfigured => _instance != null;

  /// Configures the HelpLane SDK.
  ///
  /// Must be called before using any other HelpLane functionality.
  ///
  /// [brandToken] is required and can be found in your HelpLane dashboard.
  /// [baseUrl] is optional and defaults to the HelpLane cloud instance.
  static void configure({
    required String brandToken,
    String baseUrl = 'https://app.helplane.io',
  }) {
    _instance = HelpLane._(
      brandToken: brandToken,
      baseUrl: baseUrl,
    );
  }

  /// Identifies the current user.
  ///
  /// Call this after the user logs in to associate their identity
  /// with chat conversations.
  static void identify(HelpLaneUser user) {
    instance._currentUser = user;
  }

  /// Clears the current user identity.
  ///
  /// Call this when the user logs out.
  static void clearUser() {
    instance._currentUser = null;
  }

  /// Returns the currently identified user, if any.
  static HelpLaneUser? get currentUser => instance._currentUser;

  /// Opens the chat in a modal bottom sheet.
  static Future<void> openChat(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Chat widget
              const Expanded(child: HelpLaneChat()),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the chat widget URL with user data.
  String buildChatUrl() {
    final uri = Uri.parse('$baseUrl/widget/$brandToken');

    if (_currentUser != null) {
      final userJson = jsonEncode(_currentUser!.toJson());
      final userBase64 = base64Encode(utf8.encode(userJson));
      return uri.replace(queryParameters: {'user': userBase64}).toString();
    }

    return uri.toString();
  }
}

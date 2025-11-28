# HelpLane Flutter SDK

Add live chat support to your Flutter app with the HelpLane SDK.

## Requirements

- Flutter 3.10+
- Dart 3.0+

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  helplane_flutter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Configure the SDK

```dart
import 'package:helplane_flutter/helplane_flutter.dart';

void main() {
  HelpLane.configure(brandToken: 'your-brand-token');
  runApp(MyApp());
}
```

### 2. Identify Users (Optional)

```dart
HelpLane.identify(HelpLaneUser(
  id: 'user-123',
  name: 'John Doe',
  email: 'john@example.com',
));
```

### 3. Show the Chat

```dart
// Open as modal bottom sheet
ElevatedButton(
  onPressed: () => HelpLane.openChat(context),
  child: Text('Get Help'),
)

// Or embed directly
Scaffold(
  body: HelpLaneChat(),
)
```

## Push Notifications

HelpLane uses OneSignal for push notifications:

```dart
import 'package:helplane_flutter/helplane_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// After OneSignal initialization and user identification
final externalId = HelpLanePush.getExternalUserId();
if (externalId != null) {
  OneSignal.login(externalId);
}

// Handle notification tap
OneSignal.Notifications.addClickListener((event) {
  if (HelpLanePush.isHelpLaneNotification(event.notification.additionalData)) {
    HelpLane.openChat(context);
  }
});
```

## Configuration Options

```dart
HelpLane.configure(
  brandToken: 'your-brand-token',
  baseUrl: 'https://your-instance.helplane.io', // Optional
);
```

## API Reference

### HelpLane

| Method | Description |
|--------|-------------|
| `configure(brandToken, baseUrl)` | Initialize the SDK |
| `identify(user)` | Set the current user |
| `clearUser()` | Clear user data |
| `openChat(context)` | Open chat as modal |
| `currentUser` | Get current user |
| `isConfigured` | Check if SDK is configured |

### HelpLaneUser

| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique user identifier (required) |
| `name` | String? | Display name |
| `email` | String? | Email address |
| `avatarUrl` | String? | Profile image URL |
| `customAttributes` | Map? | Custom data |

### HelpLaneChat Widget

| Property | Type | Description |
|----------|------|-------------|
| `onLoad` | VoidCallback? | Called when chat loads |
| `onError` | Function(String)? | Called on error |

## Support

- Issues: [GitHub Issues](https://github.com/intigratech/helplane-flutter/issues)

## License

MIT License - see [LICENSE](LICENSE) for details.

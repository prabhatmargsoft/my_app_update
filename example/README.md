# margsoft_in_app_update_example

Example application demonstrating the `margsoft_in_app_update` Flutter plugin.

## Features

- Check Google Play update availability.
- Check whether immediate updates are allowed.
- Check whether flexible updates are allowed.
- Start an immediate update.

## Getting Started

### 1. Add the plugin

```yaml
dependencies:
  margsoft_in_app_update: ^0.0.1
```

### 2. Import the package

```dart
import 'package:margsoft_in_app_update/margsoft_in_app_update.dart';
```

### 3. Get Android platform version

```dart
final version = await MargsoftInAppUpdate.getPlatformVersion();
print(version);
```

### 4. Check for updates

```dart
final result = await MargsoftInAppUpdate.checkForUpdate();

print('Update available: ${result['updateAvailable']}');
print('Immediate allowed: ${result['immediateAllowed']}');
print('Flexible allowed: ${result['flexibleAllowed']}');
```

### 5. Start an immediate update

```dart
final result =
    await MargsoftInAppUpdate.startImmediateUpdate();

print(result);
```

## Important Notes

- Android only.
- Google Play In-App Updates require an eligible app installed through Google Play.
- A newer version must be available on Google Play.
- Local debug installations may not support real update testing.
- Immediate updates require Google Play to allow the update flow.

## Requirements

- Flutter SDK
- Android device
- Google Play Store

## Plugin Documentation

See the main package README for complete documentation:

`../README.md`

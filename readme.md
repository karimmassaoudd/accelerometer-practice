# Accelerometer Practice (Flutter)

A small Flutter mobile app for learning how a phone accelerometer works. It is a proof of concept for the future Driving Behavior Monitor app, not the monitor itself.

## What it does

- Displays the X, Y, and Z accelerometer readings in `m/s²`.
- Starts receiving readings when **Start accelerometer** is pressed.
- Stops the stream when **Stop accelerometer** is pressed.
- Uses the [`sensors_plus`](https://pub.dev/packages/sensors_plus) plugin and Flutter's native Android/iOS integration.

The readings include gravity. When the phone is still, one axis will commonly be near `9.81` or `-9.81`; tilting or moving the phone changes the values.

## Run it

1. Connect a physical Android phone with USB debugging enabled, or start an Android emulator.
2. From this directory, run `flutter pub get`.
3. Run `flutter run`.
4. Press **Start accelerometer**, then tilt or move the device.

Use a real phone for meaningful sensor values. Desktop and many emulators do not have an accelerometer.

## Axes

- **X:** left to right across the screen.
- **Y:** bottom to top along the screen.
- **Z:** perpendicular to the screen.

The exact positive/negative direction depends on how the phone is held. Test each axis by tilting in one direction at a time.
